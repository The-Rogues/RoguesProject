# ==========================================================
# Authors: Fabian, Han
# Description:
#   Keeps track of battle turn order, processes played cards
#   signals turn transtitions between enemy and player
#   and executes enemy turn
#
# ==========================================================

extends Node
class_name BattleManager

signal battle_ended(player_won:bool)
signal card_drawn(card_data:CardData)
signal new_turn_started
@export var battle_field: BattleField
# Timer that adds delay between attacks from different enemies
@export var enemy_delay_timer: Timer
@export var energy_counter:EnergyCounter
@export var player_card_hand: CardPlayHand
@export var draw_pile: CardDeck
@export var discard_pile: CardDeck
@export var draw_pile_ui: CardDeckViewerUI
@export var discard_pile_ui: CardDeckViewerUI
@export var item_interface:ItemInterface

enum BattleState { PLAYER_TURN, ENEMY_TURN, ENDED }
var battle_state:BattleState = BattleState.PLAYER_TURN

var player_entity:BattleEntity
var enemies:Array[BattleEntity]
var living_enemies:Array[BattleEntity]
var action_queue:BattleActionQueue

var turn_count:int = 0
var held_items:Array[ItemData]

func initialize(new_player_entity:BattleEntity, 
			new_enemies:Array[BattleEntity],
			battle_object_layout:BattleObjectLayout,
			items:Array[ItemData]):
	
	player_entity = new_player_entity
	energy_counter.initialize(new_player_entity.entity_data.energy.value)
	
	for enemy in new_enemies:
		enemies.append(enemy)
		living_enemies.append(enemy)
	
	# Load Battle Objects & Battle Positions
	battle_field.initialize(battle_object_layout)
	battle_field.initialize_player(player_entity)
	action_queue = BattleActionQueue.new()
	
	for enemy in enemies:
		enemy.defeated.connect(_on_entity_defeated)
		
		new_turn_started.connect(enemy._on_new_turn_started)
		if enemy.entity_data is EnemyData:
			enemy.entity_data.choose_next_move()
	
	for item in items:
		held_items.append(item)
	
	item_interface.initialize(held_items)
	
	new_turn_started.connect(player_entity._on_new_turn_started)
	player_entity.defeated.connect(_on_entity_defeated)
	item_interface.activate_item.connect(_on_use_item)
	player_card_hand.play_card.connect(_on_try_play_card)
	discard_pile = CardDeck.new() #initialize discard_pile
	discard_pile.name = "Discard Pile"
	draw_pile.name = "Draw Pile"
	draw_pile.cards.shuffle()
	draw_pile_ui._initialize(draw_pile)
	discard_pile_ui._initialize(discard_pile)
	_start_player_turn()

func _start_player_turn():
	turn_count += 1
	if battle_state != BattleState.PLAYER_TURN:
		return
	
	if draw_pile.cards.is_empty():
		discard_pile.transfer_cards_to_deck(draw_pile, true)
	
	var drawn_cards = draw_pile.draw_cards(5)
	for card in drawn_cards:
		if card != null:
			player_card_hand.draw_card(card)
			card_drawn.emit(card)
	
	for enemy in enemies:
		var enemy_data:EnemyData = enemy.entity_data
		
		if not enemy_data:
			continue
		enemy.entity_data.choose_next_move()
		enemy.update_thought_icon(enemy_data.next_move.action_display_icon)
		if enemy.entity_data is EnemyData:
			enemy.entity_data.choose_next_move()
	
	battle_field.on_new_turn_started()
	
	energy_counter.reset_energy()
	new_turn_started.emit()


func end_player_turn() -> void:
	if battle_state != BattleState.PLAYER_TURN:
		return
	
	for card_ui in player_card_hand.card_uis:
		discard_pile.add_card(card_ui.card_data)
	player_card_hand.clear_hand()
	
	battle_state = BattleState.ENEMY_TURN
	_run_enemy_turn()

func _run_enemy_turn() -> void:
	for enemy in living_enemies:
		var next_move:BattleMove = enemy.entity_data.next_move
		enemy.hide_thought_icon()
		
		_execute_battle_move(next_move, enemy)
		enemy_delay_timer.start()
		await enemy_delay_timer.timeout
	
	if !action_queue.queue.is_empty():
		await action_queue.processed_all_actions
	
	battle_state = BattleState.PLAYER_TURN
	_start_player_turn()

func _execute_battle_move(battle_move:BattleMove, user:BattleEntity):
	if battle_move.move_type == BattleMove.MoveType.PHYSICAL:
		user.entity_animator.play("battle_entity/attack")
	elif battle_move.move_type == BattleMove.MoveType.SPECIAL:
		user.entity_animator.play("battle_entity/heal")
	
	await user.action_wait_time()
	
	for action in battle_move.actions:
		if not action:
			return
		action_queue.enqueue(action, self, user)

func _on_try_play_card(card_ui:CardUI):
	var card_data:CardData = card_ui.card_data
	if !energy_counter.can_play_card(card_data):
		player_card_hand.reject_play()
		return
	player_card_hand.confirm_play(card_ui)
	
	play_card(card_data)

func play_card(card_data:CardData):
	discard_pile.add_card(card_data)
	energy_counter.spend_energy(card_data.energy_cost)
	_execute_battle_move(card_data.move, player_entity)

func _on_use_item(item_index:int):
	held_items[item_index]._use_item(player_entity, self)
	GlobalSessionManager.consume_item(held_items[item_index])
	held_items.pop_at(item_index)
	item_interface.initialize(held_items)
	if held_items.is_empty():
		item_interface.clear_item_slots()

func _on_entity_defeated(battle_entity:BattleEntity):
	if player_entity.is_defeated:
		battle_ended.emit(false)
		
		player_card_hand.visible = false
		return
	
	if battle_entity in enemies:
		living_enemies.erase(battle_entity)
	
	if living_enemies.is_empty():
		player_card_hand.visible = false
		battle_ended.emit(true)

func _on_add_card_button_up() -> void:
	var deck:CardDeck = load("res://CardSystem/Decks/starting_card_deck.tres")
	var card_data = deck.draw_card()
	player_card_hand.draw_card(card_data)
	card_drawn.emit(card_data)
	pass # Replace with function body.
