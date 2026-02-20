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
signal started_new_turn
# Timer that adds delay between attacks from different enemies
@export var enemy_delay_timer: Timer
@export var energy_counter:EnergyCounter
@export var player_card_hand: CardPlayHand

enum BattleState { PLAYER_TURN, ENEMY_TURN, ENDED }
var battle_state:BattleState = BattleState.PLAYER_TURN

var player_entity:BattleEntity
var enemies:Array[BattleEntity]
var living_enemies:Array[BattleEntity]

var action_queue:ActionQueue
var battle_field:BattleField

func initialize(new_player_entity:BattleEntity,
		new_enemies:Array[BattleEntity],
		new_battle_field:BattleField,
		resuming: bool = false):

	#  Reset per-battle state
	battle_state = BattleState.PLAYER_TURN
	enemies.clear()
	living_enemies.clear()

	player_entity = new_player_entity
	battle_field = new_battle_field

	#  Fresh queue every time
	action_queue = ActionQueue.new()

	energy_counter.initialize(new_player_entity.entity_data.energy.value)

	for enemy in new_enemies:
		enemies.append(enemy)
		living_enemies.append(enemy)

		# connect defeated once
		if not enemy.defeated.is_connected(_on_entity_defeated):
			enemy.defeated.connect(_on_entity_defeated)

		#  Do NOT overwrite restored next_move on resume
		if enemy.entity_data is EnemyData and not resuming:
			(enemy.entity_data as EnemyData).choose_next_move()

	if not player_entity.defeated.is_connected(_on_entity_defeated):
		player_entity.defeated.connect(_on_entity_defeated)

	if not player_card_hand.play_card.is_connected(_on_try_play_card):
		player_card_hand.play_card.connect(_on_try_play_card)



func _start_player_turn():
	if battle_state != BattleState.PLAYER_TURN:
		return
	
	for enemy in enemies:
		if enemy.entity_data is EnemyData:
			var ed: EnemyData = enemy.entity_data
			if ed.next_move == null:
				ed.choose_next_move()
	
	energy_counter.reset_energy()
	started_new_turn.emit()

func end_player_turn() -> void:
	if battle_state != BattleState.PLAYER_TURN:
		return
	player_card_hand.clear_hand()
	battle_state = BattleState.ENEMY_TURN
	await _run_enemy_turn()

func _run_enemy_turn() -> void:
	for enemy in enemies:
		if not (enemy.entity_data is EnemyData):
			continue
		var next_move = (enemy.entity_data as EnemyData).next_move
		if next_move == null:
			(enemy.entity_data as EnemyData).choose_next_move()
			next_move = (enemy.entity_data as EnemyData).next_move
		enemy.hide_icon()
		if next_move.action_type == EnemyMove.Type.PHYSICAL:
			enemy.entity_animator.play("battle_entity/attack")
		elif next_move.action_type == EnemyMove.Type.SPECIAL:
			enemy.entity_animator.play("battle_entity/heal")
		
		await enemy.entity_animator.animation_finished
		
		for combat_move in enemy.entity_data.get_combat_moves():
			if combat_move == null:
				return
			
			var target:Array[BattleEntity] = get_attack_target(combat_move, enemy)
			var action_context:ActionContext = create_action_context(enemy, target)
			
			for action in combat_move.actions:
				action_queue.enqueue(action, action_context)
			#await action_queue.processed_all_actions
		
		enemy_delay_timer.start()
		await enemy_delay_timer.timeout
	
	#await action_queue.processed_all_actions
	battle_state = BattleState.PLAYER_TURN
	_start_player_turn()

func _on_try_play_card(card_ui:CardUI):
	var card_data:CardData = card_ui.card_data
	if !energy_counter.can_play_card(card_data):
		player_card_hand.return_dragged_card()
		return
	
	player_card_hand.remove_played_card(card_ui)
	energy_counter.spend_energy(card_data.energy_cost)
	execute_card(card_data)

func execute_card(card_data:CardData):
	for combat_move in card_data.play_moves:
		if combat_move == null:
			return
		
		var target:Array[BattleEntity] = get_attack_target(combat_move)
		# Only player can be the user in this case because its a card
		var action_context:ActionContext = create_action_context(player_entity, target)
		# Queues each action to be executed sequentiallt
		for action in combat_move.actions:
			action_queue.enqueue(action, action_context)

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

# Resolver for targeting
func get_attack_target(action_group:CombatMove, user:BattleEntity = null):
	var combat_entities:Array[BattleEntity]
	match action_group.targeting:
		TargetingEnum.TARGETING.SELF:
			combat_entities.append(user)
		TargetingEnum.TARGETING.PLAYER:
			combat_entities.append(player_entity)
		TargetingEnum.TARGETING.ENEMY:
			combat_entities.append(living_enemies.pick_random())
		TargetingEnum.TARGETING.ENEMIES:
			for enemy in living_enemies:
				combat_entities.append(enemy)
		TargetingEnum.TARGETING.NONE:
			pass
	return combat_entities

func create_action_context(user:BattleEntity, target:Array[BattleEntity]):
	var action_context:ActionContext = ActionContext.new(
		user,
		target,
		action_queue,
		battle_field
	)
	return action_context

func _on_add_card_button_up() -> void:
	var deck:CardDeck = load("res://CardSystem/Decks/starting_card_deck.tres")
	var card_data = deck.draw_random_card()
	player_card_hand.draw_card(card_data)
	card_drawn.emit(card_data)
	pass # Replace with function body.
