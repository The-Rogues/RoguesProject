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
@export var end_turn_button: Button
@export var battle_results_display: BattleResultLayer
#@export var item_interface:ItemInterface

const BATTLE_ENTITY = preload("res://BattleSystem/Entities/battle_entity_template.tscn")
const ENEMY_SPACING = 0.10
const ENEMY_Y_POSITION = 0.28


#var items:Array[ItemData]

func _ready() -> void:
	if GlobalSceneLoader.pending_battle_configuration:
		initialize(GlobalSceneLoader.pending_battle_configuration)
		GlobalSceneLoader.pending_battle_configuration = null

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
	battle_manager.initialize(
			character_entity, 
			enemies, 
			battle_configuration.battle_object_layout,
			battle_configuration.items
			)
	
	
	# Connect signals
	battle_manager.new_turn_started.connect(_started_player_turn)
	battle_manager.battle_ended.connect(_on_battle_ended)
	
	await battle_results_display.fade_out()
	battle_results_display.visible = false
	_started_player_turn()

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

func _on_end_turn_button_button_up() -> void:
	end_turn_button.disabled = true
	battle_manager.end_player_turn()
	pass # Replace with function body.

func _started_player_turn():
	end_turn_button.disabled = false

func _on_battle_ended(player_won:bool):
	end_turn_button.visible = false
	if player_won:
		await get_tree().create_timer(3).timeout
		battle_results_display.set_result(player_won, 
				character_entity, 
				battle_manager.enemies)
	else:
		await get_tree().create_timer(0.5).timeout
		battle_results_display.set_result(player_won, 
				character_entity, 
				battle_manager.enemies)

func _on_button_button_up() -> void:
	var action = DamageEntityAction.new()
	action.damage = 20
	battle_manager.action_queue.enqueue(action, battle_manager, null)
	pass # Replace with function body.


func _on_test_enemy_damage_button_up() -> void:
	var action = DamageEntityAction.new()
	action.damage = 20
	action.target = TargetedBattleAction.TargetType.ENEMY

	battle_manager.action_queue.enqueue(action, battle_manager, null)
	pass # Replace with function body.


func _on_win_button_up() -> void:
	for enemy in battle_manager.enemies:
		enemy.kill()
	pass # Replace with function body.
