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
@export var end_turn_button: Button
@export var battle_results_display: BattleResultLayer


func _ready() -> void:
	if GlobalSceneLoader.pending_battle_configuration:
		initialize(GlobalSceneLoader.pending_battle_configuration)
		GlobalSceneLoader.pending_battle_configuration = null


func initialize(battle_configuration:BattleSceneConfiguration):
	# Setup Battle Manager
	battle_manager.initialize(
			battle_configuration.character_entity_data, 
			battle_configuration.enemy_encounter, 
			battle_configuration.object_layout,
			battle_configuration.held_items,
			battle_configuration.personality_data,
			battle_configuration.card_deck,
			battle_configuration.energy,
			battle_configuration.current_character_health
	)
	
	# Connect signals
	battle_manager.new_turn_started.connect(_started_player_turn)
	battle_manager.battle_ended.connect(_on_battle_ended)
	
	await battle_results_display.fade_out()
	battle_results_display.visible = false
	_started_player_turn()


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
		battle_results_display.set_result(
				player_won, 
				battle_manager.player_entity, 
				battle_manager.enemy_encounter
		)
	else:
		await get_tree().create_timer(0.5).timeout
		battle_results_display.set_result(
				player_won, 
				battle_manager.player_entity, 
				battle_manager.enemy_encounter
		)


func _on_button_button_up() -> void:
	battle_manager.player_entity.take_damage(20, null)
	pass # Replace with function body.


func _on_test_enemy_damage_button_up() -> void:
	battle_manager.living_enemies.pick_random().take_damage(20, null)


func _on_win_button_up() -> void:
	for enemy in battle_manager.living_enemies:
		enemy.kill()
	pass # Replace with function body.
