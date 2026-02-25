extends Node2D
class_name BattleManager

signal battle_ended(player_won:bool)
signal card_drawn(card_data:CardData)
signal played_card(card_data:CardData)
signal new_turn_started
signal player_turn_ended
signal enemy_turn_ended
signal item_used(
		item:ItemData,
		remaining:Array[ItemData]
)

@export var battle_field: BattleField

@export var energy_counter:EnergyCounter
@export var battle_card_manager:BattleCardManager

@export var battle_display:GameSessionDisplay

@export var enemy_delay_timer: Timer
@onready var action_delay_timer: Timer = $ActionDelayTimer


@onready var entity_parent: Node2D = $Entities
@onready var character_spawn_point: Node2D = $Entities/CharacterSpawnPoint

enum BattleState { PLAYER_TURN, ENEMY_TURN, ENDED }
var battle_state:BattleState = BattleState.PLAYER_TURN

var player_entity:BattleEntity
var enemies:Array[BattleEntity]
var living_enemies:Array[BattleEntity]
var enemy_encounter:EnemyEncounter

var action_queue:BattleActionQueue
var action_intentions:Dictionary[BattleEntity, BattleIntentIcon]
var battle_events:BattleEventsManager

var turn_count:int = 0
var held_items:Array[ItemData]
var character_personality:PersonalityData

const INTENT_ICON = preload("res://Battle/UI/battle_intent_icon.tscn")
const BATTLE_ENTITY = preload("res://Entities/Scenes/battle_entity.tscn")

const ENEMY_SPACING = 0.10
const ENEMY_Y_POSITION = 0.28


func initialize(
			character_entity_data:EntityData,
			new_enemy_encounter:EnemyEncounter,
			battle_object_layout:BattleObjectLayout,
			items:Array[ItemData],
			personality_data:PersonalityData,
			starting_card_deck:CardDeck,
			energy:int,
			current_character_health:int
) -> void:
	# Spawn Player
	var new_character_entity:BattleEntity = BATTLE_ENTITY.instantiate()
	entity_parent.add_child(new_character_entity)
	new_character_entity.global_position = character_spawn_point.global_position
	new_character_entity.initialize(character_entity_data, current_character_health)
	new_character_entity.defeated.connect(_on_entity_defeated)
	new_turn_started.connect(new_character_entity._on_new_turn_started)
	
	# Spawn Enemies
	for entity_data in new_enemy_encounter.enemies:
		var new_enemy_entity:BattleEntity = BATTLE_ENTITY.instantiate()
		entity_parent.add_child(new_enemy_entity)
		enemies.append(new_enemy_entity)
		living_enemies.append(new_enemy_entity)
		new_enemy_entity.initialize(entity_data)
		new_enemy_entity.defeated.connect(_on_entity_defeated)
		new_turn_started.connect(new_enemy_entity._on_new_turn_started)
	
	_position_enemies(enemies)
	
	# Storing
	player_entity = new_character_entity
	character_personality = personality_data
	enemy_encounter = new_enemy_encounter
	
	# Load Battle Objects & Battle Positions
	battle_field.initialize(battle_object_layout, player_entity)
	action_queue = BattleActionQueue.new()
	battle_events = BattleEventsManager.new()
	battle_events.initialize(self)
	
	# Setting up Cards
	battle_card_manager.initialize(starting_card_deck)
	battle_card_manager.try_play_card.connect(_on_try_play_card)
	energy_counter.initialize(energy)
	
	# Setting up items
	held_items = items.duplicate(true)
	
	# Setting battle display
	battle_display.initialize_with_battle(self, starting_card_deck)
	battle_display.item_interface.activate_item.connect(_on_use_item)
	
	player_entity.damaged.connect(_on_player_damaged)
	
	# Starting Battle
	#_start_player_turn()


func _on_player_damaged(amount:int):
	character_personality.defensive_trait.process_damage(self)
	pass


func _position_enemies(enemies:Array[BattleEntity]):
	if enemies.is_empty():
		return
	
	var viewport_size = get_viewport_rect().size
	var center_x = viewport_size.x / 2.0
	var y = viewport_size.y * ENEMY_Y_POSITION
	
	var spacing = viewport_size.x * ENEMY_SPACING
	var count = enemies.size()
	var total_width = (count - 1) * spacing
	var start_x = center_x - total_width / 2.0
	
	if enemies.size() == 1:
		enemies[0].global_position = Vector2(center_x, y)
		return
	
	for i in range(0, enemies.size()):
		enemies[i].global_position = Vector2(start_x + i * spacing, y)


func action_delay():
	action_delay_timer.start()
	await action_delay_timer.timeout


func create_action_intent(entity:BattleEntity):
	var next_move:BattleMove = entity.data.get_battle_move()
	var new_intent_icon:BattleIntentIcon = INTENT_ICON.instantiate()
	entity.add_child(new_intent_icon)
	new_intent_icon.global_position.y -= 70
	new_intent_icon.global_position.x -= 12
	new_intent_icon.initialize(next_move)
	action_intentions[entity] = new_intent_icon


func resolve_enemy_intention(entity:BattleEntity):
	if entity.is_defeated:
		action_intentions.erase(entity)
		return
	var intent_icon:BattleIntentIcon = action_intentions[entity]
	#var actions:Array[BattleAction] = intent_icon.battle_move.actions
	await intent_icon.resolve()
	
	_execute_battle_move(intent_icon.battle_move, entity)


func _start_player_turn():
	turn_count += 1
	if battle_state != BattleState.PLAYER_TURN:
		return
	
	player_entity.parry.set_to_zero()
	player_entity.defense.set_to_zero()
	
	battle_card_manager.reshuffle_deck()
	battle_card_manager.draw_card(5)
	
	for enemy in living_enemies:
		create_action_intent(enemy)
		enemy.status_conditions.decay_status_effects()
	
	battle_field.on_new_turn_started()
	
	energy_counter.reset_energy()
	new_turn_started.emit()


func end_player_turn() -> void:
	if battle_state != BattleState.PLAYER_TURN:
		return
	
	player_entity.status_conditions.decay_status_effects()
	
	for enemy in living_enemies:
		enemy.parry.set_to_zero()
		enemy.defense.set_to_zero()
	
	battle_card_manager.transfer_hand_to_discard()
	
	player_turn_ended.emit()
	battle_state = BattleState.ENEMY_TURN


func _start_enemy_turn() -> void:
	await get_tree().create_timer(0.5).timeout
	for entity in action_intentions:
		enemy_delay_timer.start()
		resolve_enemy_intention(entity)
		await enemy_delay_timer.timeout
	
	if !action_queue.queue.is_empty():
		await action_queue.processed_all_actions
	
	enemy_turn_ended.emit()
	await get_tree().create_timer(1.2).timeout
	
	battle_state = BattleState.PLAYER_TURN
	_start_player_turn()


func _execute_battle_move(battle_move:BattleMove, user:BattleEntity):
	if battle_move.move_type == BattleMove.MoveType.PHYSICAL:
		user.animation_player.play("entity/attack")
	elif battle_move.move_type == BattleMove.MoveType.SPECIAL:
		user.animation_player.play("entity/heal")
	
	await action_delay()
	for action in battle_move.actions:
		if not action:
			return
		
		action_queue.enqueue(action, self, user)
	user.animation_player.play("entity/idle")


func _on_try_play_card(card_ui:CardUI):
	var card_data:CardData = card_ui.card_data
	if !energy_counter.can_play_card(card_data):
		battle_card_manager.reject_play()
	else:
		#battle_card_manager.player_card_hand.confirm_play(card_ui)
		battle_card_manager.play_card(card_ui)
		process_card(card_data)


func process_card(card_data:CardData):
	energy_counter.spend_energy(card_data.energy_cost)
	_execute_battle_move(card_data.move, player_entity)


func _on_use_item(item_index:int):
	held_items[item_index]._use_item(player_entity, self)
	GlobalSessionManager._remove_held_item(held_items[item_index])
	
	var used_item:ItemData = held_items.pop_at(item_index)
	#item_interface.initialize(held_items)
	item_used.emit(used_item, held_items)
	#if held_items.is_empty():
	#	item_interface.clear_item_slots()


func _on_entity_defeated(battle_entity:BattleEntity):
	if player_entity.is_defeated:
		battle_ended.emit(false)
		
		battle_card_manager.hide_hand()
		return
	
	if battle_entity in enemies:
		living_enemies.erase(battle_entity)
	
	if living_enemies.is_empty():
		battle_card_manager.hide_hand()
		battle_ended.emit(true)
	
	if action_intentions.has(battle_entity):
		await action_intentions[battle_entity].resolve()
		action_intentions[battle_entity].queue_free()
		action_intentions.erase(battle_entity)
