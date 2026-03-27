extends Node2D
class_name BattleManager

signal battle_ended(player_won:bool)
signal new_turn_started
signal player_turn_ended
signal enemy_turn_ended

enum TargetingOption {
	## Targeting chooses the entity who is executing the action.
	USER, 
	## Targeting chooses the player's character.
	PLAYER, 
	## Targeting chooses a random enemy by default. If character personality has
	## a bias towards specified types of entites, they are chosen instead. 
	ENEMY, 
	## Targeting chooses all enemies who are still alive.
	ALL_ENEMIES, 
	## Targeting is not defined by this instance. Available in case another
	## action needs to override targeting of another action.
	LAST_TARGET
}
# Sets what en

@export var battle_field: BattleField
@export var energy_counter:EnergyCounter
@export var battle_card_manager:BattleCardManager

@export var enemy_delay_timer: Timer
@onready var action_delay_timer: Timer = $ActionDelayTimer

@onready var entity_parent: Node2D = $Entities
@onready var player_spawn_point: Node2D = $Entities/CharacterSpawnPoint

var last_targets:Array[Entity]

enum BattleState { PLAYER_TURN, ENEMY_TURN, ENDED }
var battle_state:BattleState = BattleState.PLAYER_TURN

var player_entity:BattleEntity
var enemies:Array[BattleEntity]

var action_queue:BattleActionQueue
var action_intentions:Dictionary[BattleEntity, BattleIntentIcon]
var battle_events:BattleEventsManager

var turn_count:int = 0
var player_personality:PersonalityData

const INTENT_ICON = preload("res://Battle/UI/battle_intent_icon.tscn")
const BATTLE_ENTITY = preload("res://Entities/Scenes/battle_entity.tscn")

const ENEMY_SPACING = 0.10
const ENEMY_Y_POSITION = 0.28

# Fletcher
@onready var ai_processer_script: PackedScene = preload("res://ai/processer/AiCardProcesser.tscn")
@onready var ai_processer: AiCardProcesser = ai_processer_script.instantiate()


func initialize(battle_config:BattleSceneConfiguration) -> void:
	# Spawn & initialize Player
	var new_player_entity:BattleEntity = BATTLE_ENTITY.instantiate()
	entity_parent.add_child(new_player_entity)
	new_player_entity.global_position = player_spawn_point.global_position
	new_player_entity.initialize(
		battle_config.character_entity_data, 
		battle_config.current_character_health
	)
	# Storing player info
	player_entity = new_player_entity
	player_personality = battle_config.personality_data
	
	# Spawn & initialize Enemies
	for entity_data in battle_config.enemy_encounter.enemies:
		var new_enemy_entity:BattleEntity = BATTLE_ENTITY.instantiate()
		entity_parent.add_child(new_enemy_entity)
		enemies.append(new_enemy_entity)
		new_enemy_entity.initialize(entity_data)
		new_enemy_entity.defeated.connect(_on_entity_defeated)
		new_turn_started.connect(new_enemy_entity._on_new_turn_started)
	
	_position_enemies()
	
	# Load Battle Objects & Battle Positions
	battle_field.initialize(battle_config.object_layout, player_entity)
	action_queue = BattleActionQueue.new()
	battle_events = BattleEventsManager.new()
	battle_events.initialize(self)
	
	# Setting up Cards
	battle_card_manager.initialize(
		battle_config.card_deck,
		player_entity,
		self
	)
	battle_card_manager.try_play_card.connect(_on_try_play_card)
	energy_counter.initialize(battle_config.energy)
	
	# Connect signals
	new_player_entity.defeated.connect(_on_entity_defeated)
	new_turn_started.connect(new_player_entity._on_new_turn_started)
	player_entity.damaged.connect(_on_player_damaged)
	
	# Fletcher
	add_child(ai_processer)


func _on_player_damaged(amount:int):
	player_personality.defensive_trait.process_damage(self)
	pass


func _position_enemies():
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


func resolve_action_targeting(
	action:TargetedBattleAction,
	user:BattleEntity
	) -> Array[Entity]:
		
	if user != player_entity and !battle_field.find_objects("dummy").is_empty():
		var pos:Array[BattlePosition] = battle_field.find_objects("dummy")
		return [pos[0].object] as Array[Entity]
	
	match action.targeting:
		TargetingOption.USER:
			return [user] as Array[Entity]
		TargetingOption.PLAYER:
			var battle_object = battle_field.get_object()
			if battle_object:
				if battle_object.intercepts():
					return [battle_object] as Array[Entity]
			
			return [player_entity] as Array[Entity]
		TargetingOption.ENEMY:
			# Target an enemy the character is biased towards if user is the
			# player character.
			if user == player_entity:
				return [
					player_personality.get_target_entity(
							enemies
					)
				]
			# Otherwise, assume enemy is targeting allies, excluding self.
			var target_canidates:Array[BattleEntity] = enemies
			if target_canidates.has(user):
				target_canidates.erase(user)
			return [target_canidates.pick_random()] as Array[Entity]
		TargetingOption.ALL_ENEMIES:
			return enemies as Array[Entity]
		_:
			printerr("Unresolvable targeting in TargetedBattleAction")
			return [] as Array[Entity]
		TargetingOption.LAST_TARGET:
			if !last_targets:
				return []
			else:
				return last_targets as Array[Entity]


func _start_player_turn():
	if battle_state != BattleState.PLAYER_TURN:
		return
	turn_count += 1
	
	player_entity.parry.set_to_zero()
	player_entity.defense.set_to_zero()
	
	battle_card_manager.reshuffle_deck()
	battle_card_manager.draw_card(5)
	
	for enemy in enemies:
		create_action_intent(enemy)
	
	battle_field.on_new_turn_started()
	
	energy_counter.reset_energy()
	new_turn_started.emit()


func end_player_turn() -> void:
	if battle_state != BattleState.PLAYER_TURN:
		return
	
	player_entity.status_conditions.decay_status_effects()
	
	for enemy in enemies:
		enemy.parry.set_to_zero()
		enemy.defense.set_to_zero()
		enemy.status_conditions.decay_status_effects()
	
	battle_card_manager.transfer_hand_to_discard()
	
	player_turn_ended.emit()
	battle_state = BattleState.ENEMY_TURN


func _start_enemy_turn() -> void:
	await get_tree().create_timer(0.5).timeout
	for entity in action_intentions:
		if entity.is_defeated:
			continue
		enemy_delay_timer.start()
		await resolve_enemy_intention(entity)
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
		
		if action is TargetedBattleAction:
			action.targets = resolve_action_targeting(action, user)
			last_targets = action.targets
		
		action_queue.enqueue(action, self, user)
	user.animation_player.play("entity/idle")


func _on_try_play_card(card_ui:CardUI):
	var card_data:CardData = card_ui.card_data
	if !energy_counter.can_play_card(card_data):
		battle_card_manager.reject_play()
	else:
		battle_card_manager.play_card(card_ui)
		process_card(card_data)


func process_card(card_data:CardData):
	energy_counter.spend_energy(card_data.energy_cost)
	if card_data is AiCardData:
		var new_card = await ai_processer.process_card(player_personality, card_data)
		battle_card_manager.draw_card(1, new_card)
	else:
		_execute_battle_move(card_data.move, player_entity)


func _on_entity_defeated(battle_entity:BattleEntity):
	if player_entity.is_defeated:
		battle_ended.emit(false)
		battle_card_manager.hide_hand()
	elif battle_entity in enemies:
		enemies.erase(battle_entity)
	
	if enemies.is_empty():
		battle_card_manager.hide_hand()
		battle_ended.emit(true)
	
	if action_intentions.has(battle_entity):
		await action_intentions[battle_entity].resolve()
		action_intentions[battle_entity].queue_free()
		action_intentions.erase(battle_entity)
