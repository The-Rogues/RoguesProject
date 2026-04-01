# ==========================================================
# Authors: Fabian, Han
# Description:
#   Mediator between card input and battle manager
#   Executes visual turn transitions and calls results screen
#
# ==========================================================

extends Node2D
class_name BattleScene

@export var battle_display:GameSessionDisplay
@export var battle_manager: BattleManager
@export var end_turn_button: Button
@export var lose_screen: LoseScreen

@export var turn_banner: BannerPopup
@export var battle_win_screen: BattleWinScreen
@onready var battle_interface: Control = $UILayer/BattleInterface
@onready var finisher: ColorRect = $Finisher

var enemy_encounter:EnemyEncounter

const FLOATING_NUMBERS = preload(
		"res://General/UI/DamageNumbers/floating_numbers.tscn"
)

func _ready() -> void:
	end_turn_button.disabled = true
	
	if GlobalSceneLoader.pending_battle_configuration:
		initialize(GlobalSceneLoader.pending_battle_configuration)
		GlobalSceneLoader.pending_battle_configuration = null
		GlobalSessionManager.gold_added.connect(_on_collected_gold)


func initialize(battle_configuration:BattleSceneConfiguration):
	# Setup Battle Manager
	battle_manager.initialize(battle_configuration)
	
	enemy_encounter = battle_configuration.enemy_encounter
	
	# Connect signals
	battle_manager.new_turn_started.connect(_started_player_turn)
	battle_manager.battle_ended.connect(_on_battle_ended)
	battle_display.initialize_with_battle(battle_manager, battle_configuration.card_deck)
	
	lose_screen.visible = false
	await get_tree().create_timer(0.5).timeout
	await turn_banner.display("Battle Start")
	battle_manager._start_player_turn()
	end_turn_button.disabled = false


func _on_end_turn_button_up() -> void:
	end_turn_button.disabled = true
	end_turn_button.text = "Enemy Turn"
	battle_manager.end_player_turn()
	await turn_banner.display("Enemy Turn")
	battle_manager._start_enemy_turn()
	pass # Replace with function body.


func _started_player_turn():
	await turn_banner.display("Player Turn\nTurn " + str(battle_manager.turn_count))
	end_turn_button.disabled = false
	end_turn_button.text = "End Turn"


func _on_battle_ended(player_won:bool):
	end_turn_button.visible = false
	if player_won:
		_play_win_sequence()
	else:
		lose_screen.visible = true
		await lose_screen.play_lose_sequence(battle_manager.player_entity)
		lose_screen.display_game_results()


func _play_win_sequence():
	finisher.visible = true
	battle_display.visible = false
	battle_interface.visible = false
	
	Engine.time_scale = 0.35
	await get_tree().create_timer(0.6).timeout
	Engine.time_scale = 1
	finisher.visible = false
	battle_interface.visible = true
	battle_display.visible = true
	
	await get_tree().create_timer(1).timeout
	GlobalSessionManager.increase_gold(enemy_encounter.get_gold_reward())
	await get_tree().create_timer(4).timeout
	battle_interface.visible = false
	battle_win_screen.visible = true
	GlobalSessionManager.complete_current_room()
	
	battle_win_screen.initialize(
		enemy_encounter,
		battle_manager
	)
	


func display_floating_numbers(text:String, position:Vector2):
	var new_pop_text = FLOATING_NUMBERS.instantiate()
	add_child(new_pop_text)
	new_pop_text.global_position = position
	
	new_pop_text.initialize(text, Color.ORANGE)


func _on_collected_gold(new_value:int):
	display_floating_numbers(str(new_value), battle_manager.player_entity.global_position)
	pass
