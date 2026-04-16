extends Control

@export var main_menu:Control
@export var continue_button: SelectButton 
@export var snapshot:Control
@export var continue_menu: VBoxContainer
@export var character_menu: VBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	snapshot.initialize()
	
	continue_button.set_disabled(
		!GlobalSaveManager.has_save())
	
	continue_menu.visible = true
	character_menu.visible = false



func _on_continue_clicked() -> void:
	#var p: RunProgress = GlobalSaveManager.load_run()
	#print("continue 1")
	#if p == null:
	#	return
	#print("continue 2")
	#GlobalSessionManager.run_progress = p
	GlobalSessionManager.initialize_map()
	#GlobalSessionManager.run_progress = p
	#GlobalSessionManager.started_session = true
	GlobalSessionInterface.visible = true
	GlobalSceneLoader.load_scene(GlobalSceneLoader.MAP_SCENE_PATH)


func _on_start_new_clicked() -> void:
	GlobalSaveManager.reset()
	GlobalSessionManager.run_progress = null
	get_viewport().gui_disable_input = false
	continue_menu.visible = false
	character_menu.visible = true
	continue_button.set_disabled(true)
	
	#GlobalSceneLoader.load_scene(GlobalSceneLoader.CHARACTER_GENERATOR_PATH)
	pass # Replace with function body.


func _on_return_clicked() -> void:
	visible = false
	main_menu.visible = true
	pass # Replace with function body.


func _on_delete_save() -> void:
	GlobalSaveManager.reset()
	GlobalSessionManager.run_progress = null
	get_viewport().gui_disable_input = false
	
	continue_button.set_disabled(true)
	pass # Replace with function body.


func _on_return_from_character_menu_clicked() -> void:
	character_menu.visible = false
	continue_menu.visible = true
	pass # Replace with function body.


func _on_create_random_character_clicked() -> void:
	GlobalSceneLoader.load_scene(GlobalSceneLoader.Random_Character_Builder, false)
	pass # Replace with function body.


func _on_ai_generate_character_clicked() -> void:
	GlobalSceneLoader.load_scene(GlobalSceneLoader.AI_Character_Builder, false)
	pass # Replace with function body.


func _on_character_builder_clicked() -> void:
	GlobalSceneLoader.load_scene(GlobalSceneLoader.Character_Builder, false)
	pass # Replace with function body.
