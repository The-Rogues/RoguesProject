# Author: Nathaniel
# Edited: Fabian

# Handles screen navigation logic to access different elements of main menu
extends Node2D

@onready var main_menu: Control = $UILayer/Control/MainMenu
@onready var options_menu: OptionsMenu = $UILayer/Control/OptionsMenu
@onready var credits_menu: Control = $UILayer/Control/CreditsMenu
@onready var close_menu: Control = $UILayer/Control/CloseMenu
@onready var start_run_button: Button = $UILayer/Control/MainMenu/MarginContainer/MainMenuElements/VBoxContainer/StartRun
@onready var reset_run_button: Button = $UILayer/Control/MainMenu/MarginContainer/MainMenuElements/VBoxContainer/Reset
@onready var resume_battle_button: Button = $UILayer/Control/MainMenu/MarginContainer/MainMenuElements/VBoxContainer/ResumeBattle



func _ready() -> void:
	_update_start_button_text()
	main_menu.visible = true
	options_menu.visible = false
	credits_menu.visible = false
	close_menu.visible = false
	options_menu.close.connect(show_main_menu)
	_update_menu_buttons()



func show_main_menu():
	main_menu.visible = true

func _on_quit_button_up() -> void:
	close_menu.visible = true
	main_menu.visible = false
	await get_tree().create_timer(3).timeout
	get_tree().quit()
	pass # Replace with function body.

func _on_credits_button_up() -> void:
	credits_menu.visible = true
	main_menu.visible = false
	pass # Replace with function body.

func _on_go_back_credits_button_up() -> void:
	credits_menu.visible = false
	main_menu.visible = true
	pass # Replace with function body.


func _on_options_button_up() -> void:
	options_menu.visible = true
	main_menu.visible = false
	pass # Replace with function body.


func _on_start_run_button_up() -> void:
	if GlobalSaveManager.has_save():
		_load_run()
	else:
		_start_new_run()

func _on_resume_battle_button_up() -> void:
	var p: RunProgress = GlobalSaveManager.load_run()
	if p == null:
		GlobalSaveManager.reset()
		_update_menu_buttons()
		return

	if p.battle == null or (not p.battle.is_active) or p.battle.enemies.is_empty():
		_update_menu_buttons()
		return

	GlobalSessionManager.run_progress = p
	GlobalSessionManager.started_session = true

	GlobalSceneLoader.load_battle_scene()


func _update_start_button_text() -> void:
	start_run_button.text = "Load Run" if GlobalSaveManager.has_save() else "Start Run"
	
func _load_run() -> void:
	var p: RunProgress = GlobalSaveManager.load_run()
	if p == null:
		GlobalSaveManager.reset()
		_update_start_button_text()
		return

	GlobalSessionManager.run_progress = p
	GlobalSessionManager.initialize_map()
	GlobalSessionManager.run_progress = p
	GlobalSessionManager.started_session = true

	GlobalSceneLoader.load_scene(GlobalSceneLoader.MAP_SCENE_PATH)
	
func _start_new_run() -> void:
	var p: RunProgress = RunProgress.new(null, "")
	p.map_seed = randi()
	p.player_node_index = 0

	GlobalSaveManager.save_run(p)
	GlobalSessionManager.run_progress = p
	GlobalSceneLoader.load_scene(GlobalSceneLoader.CHARACTER_GENERATOR_PATH)

func _on_reset_button_up() -> void:
	GlobalSaveManager.reset()
	GlobalSessionManager.run_progress = null
	get_viewport().gui_disable_input = false
	_update_menu_buttons()

	
func _update_menu_buttons() -> void:
	var has := GlobalSaveManager.has_save()

	# Start button becomes Load if any save exists
	start_run_button.text = "Load Run" if has else "Start Run"

	# Reset visible if any save exists
	reset_run_button.visible = has

	# Resume only if battle snapshot exists
	resume_battle_button.visible = _has_resumable_battle()

func _has_resumable_battle() -> bool:
	if not GlobalSaveManager.has_save():
		return false

	var p: RunProgress = GlobalSaveManager.load_run()
	if p == null:
		return false

	return (
		p.battle != null
		and p.battle.is_active
		and not p.battle.enemies.is_empty()
	)
