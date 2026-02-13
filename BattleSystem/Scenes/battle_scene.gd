# ==========================================================
# Authors: Fabian, Han
# Description:
#   Mediator between card input and battle manager
#   Executes visual turn transitions and calls results screen
#
# ==========================================================

extends Node2D
class_name BattleScene

@export var battle_manager: BattleManager
@export var character_entity: BattleEntity
@export var battle_field: BattleField
@export var end_turn_button: Button
@export var battle_results_display: BattleResultLayer
@export var item_interface:ItemInterface

const BATTLE_ENTITY = preload("res://BattleSystem/Entities/battle_entity_template.tscn")
const ENEMY_SPACING = 0.10
const ENEMY_Y_POSITION = 0.28

var items:Array[ItemData]

func _ready() -> void:
	var pd := GlobalSaveManager.get_or_create()
	# 1) New battle path (normal)
	if GlobalSceneLoader.pending_battle_configuration:
		initialize(GlobalSceneLoader.pending_battle_configuration)
		GlobalSceneLoader.pending_battle_configuration = null
		_save_battle_snapshot()
		return

	# 2) Resume path (no pending configuration)
	var p := GlobalSaveManager.get_or_create()
	GlobalSessionManager.run_progress = p # keep memory in sync
	if p != null and p.battle != null and p.battle.is_active and not p.battle.enemies.is_empty():
		_initialize_from_save(p)
		return

func initialize(battle_configuration:BattleSceneConfiguration):
	# Load player
	character_entity.initialize(battle_configuration.character_data)
	
	# Load enemies
	var enemies:Array[BattleEntity]
	for enemy_data in battle_configuration.enemies:
		var new_enemy:BattleEntity = BATTLE_ENTITY.instantiate()
		add_child(new_enemy)
		enemies.append(new_enemy)
		new_enemy.initialize(enemy_data)
	
	_position_enemies(enemies)
	
	# Setup Battle Manager
	battle_manager.initialize(character_entity, enemies, battle_field)
	battle_manager.action_queue.processed_all_actions.connect(_save_battle_snapshot)
	
	# Load Battle Objects & Battle Positions
	battle_field.initialize(battle_configuration.battle_object_layout)
	battle_field.initialize_player(character_entity)
	
	# Setup Item Interface
	for item in battle_configuration.items:
		items.append(item)
	
	item_interface.initialize(items)
	
	# Connect signals
	battle_manager.started_new_turn.connect(_started_player_turn)
	battle_manager.battle_ended.connect(_on_battle_ended)
	item_interface.activate_item.connect(_on_use_item)
	
	battle_results_display.visible = true
	await battle_results_display.fade_out()
	_started_player_turn()
	_save_battle_snapshot()

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

func _on_use_item(item_index:int):
	GlobalSessionManager.consume_item(items[item_index])
	items.pop_at(item_index)
	item_interface.initialize(items)
	if items.is_empty():
		item_interface.clear_item_slots()

func _on_end_turn_button_button_up() -> void:
	end_turn_button.disabled = true
	battle_manager.end_player_turn()
	_save_battle_snapshot()
	pass # Replace with function body.

func _started_player_turn():
	if battle_field != null:
		battle_field.on_new_turn_started()

	end_turn_button.disabled = false

	for i in range(0, 5):
		battle_manager._on_add_card_button_up()


func _on_battle_ended(player_won:bool):
	end_turn_button.visible = false
	var p := GlobalSessionManager.run_progress
	if p != null and p.battle != null:
		p.battle.is_active = false
		p.battle.enemies.clear()
		GlobalSaveManager.save_run(p)
	if player_won:
		await get_tree().create_timer(3).timeout
		battle_results_display.set_result(player_won, 
				character_entity, 
				battle_manager.enemies)
	else:
		await character_entity.entity_animator.animation_finished
		battle_results_display.set_result(player_won, 
				character_entity, 
				battle_manager.enemies)

func _on_button_button_up() -> void:
	var action = DamageAction.new()
	action.damage = 20
	var action_context = battle_manager.create_action_context(null, [character_entity])
	battle_manager.action_queue.enqueue(action, action_context)
	pass # Replace with function body.


func _on_test_enemy_damage_button_up() -> void:
	var action = DamageAction.new()
	action.damage = 20
	var entity = battle_manager.living_enemies.pick_random()
	if !entity:
		return
	
	if entity.is_defeated:
		return
	var action_context = battle_manager.create_action_context(character_entity, [entity])
	battle_manager.action_queue.enqueue(action, action_context)
	_save_battle_snapshot()
	pass # Replace with function body.


func _on_win_button_up() -> void:
	for enemy in battle_manager.enemies:
		print(enemy)
		enemy.kill()
	pass # Replace with function body.
	
func _initialize_from_save(p: RunProgress) -> void:
	character_entity.initialize(p.character_data)

	var enemies_arr: Array[BattleEntity] = []
	for snap in p.battle.enemies:
		if snap == null or snap.enemy_data == null:
			continue

		var new_enemy: BattleEntity = BATTLE_ENTITY.instantiate()
		add_child(new_enemy)
		enemies_arr.append(new_enemy)

		# initializes + duplicates EnemyData, creates health stat, etc.
		new_enemy.initialize(snap.enemy_data)

		# Restore HP safely: rebuild Stat then set current
		if new_enemy.entity_data != null:
			new_enemy.initialize(snap.enemy_data)
			new_enemy.entity_data.health.value = snap.current_hp
			new_enemy.entity_data.health.value_changed.emit(new_enemy.entity_data.health.value)



		# Restore next move (intent)
		if new_enemy.entity_data is EnemyData and snap.next_move_index >= 0:
			var ed := new_enemy.entity_data as EnemyData
			if snap.next_move_index < ed.move_set.size():
				ed.next_move = ed.move_set[snap.next_move_index]
				ed.new_move_chosen.emit(ed.next_move)

	_position_enemies(enemies_arr)

	# Initialize field BEFORE turns start 
	battle_field.initialize(GlobalSceneLoader.FLOOR_1_SPAWN_POOL.get_object_layout())
	battle_field.initialize_player(character_entity)

	battle_field.opportunities.clear()
	battle_field.player_on_opportunity = false

	# Initialize battle manager in "resuming" mode
	battle_manager.initialize(character_entity, enemies_arr, battle_field, true)

	# Connect snapshot saving once
	if not battle_manager.action_queue.processed_all_actions.is_connected(_save_battle_snapshot):
		battle_manager.action_queue.processed_all_actions.connect(_save_battle_snapshot)

	# Items
	items = []
	for it in p.heald_items:
		items.append(it)
	item_interface.initialize(items)

	# Connect signals once
	if not battle_manager.started_new_turn.is_connected(_started_player_turn):
		battle_manager.started_new_turn.connect(_started_player_turn)

	if not battle_manager.battle_ended.is_connected(_on_battle_ended):
		battle_manager.battle_ended.connect(_on_battle_ended)

	if not item_interface.activate_item.is_connected(_on_use_item):
		item_interface.activate_item.connect(_on_use_item)

	battle_results_display.visible = true
	await battle_results_display.fade_out()
	_started_player_turn()


func _save_battle_snapshot() -> void:
	var p := GlobalSessionManager.run_progress
	if p == null:
		return

	if p.battle == null:
		p.battle = BattleSaveData.new()

	p.battle.is_active = true
	p.battle.resume_node_index = p.player_node_index
	p.battle.enemies.clear()

	for e in battle_manager.enemies:
		if e == null or e.entity_data == null:
			continue
		if not (e.entity_data is EnemyData):
			continue

		var ed := e.entity_data as EnemyData
		var snap := EnemySnapshot.new()

		# identity/state
		snap.enemy_data = ed.duplicate(true)

		# current hp 
		if ed.health == null:
			ed.health = Stat.new(ed.health_points, 0, 0, true)
			ed.health.initialize()
		snap.current_hp = int(ed.health.value)

		# next move index
		if ed.next_move != null:
			snap.next_move_index = ed.move_set.find(ed.next_move)

		p.battle.enemies.append(snap)

	GlobalSaveManager.save_run(p)
