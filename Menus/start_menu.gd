extends Control

@export var main_menu:Control
@onready var continue_button: SelectButton = $OptionsMarhin/Elements/Continue
@onready var delete_button: SelectButton = $OptionsMarhin/Elements/Delete

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if GlobalSaveManager.has_save():
		GlobalSessionManager.run_progress = GlobalSaveManager.load_run()
	
	continue_button.set_disabled(
		!GlobalSaveManager.has_save()
	)
	delete_button.set_disabled(
		!GlobalSaveManager.has_save()
	)



func _on_continue_clicked() -> void:
	var p: RunProgress = GlobalSaveManager.load_run()
	
	if p == null:
		return
	GlobalSessionManager.run_progress = p
	GlobalSessionManager.initialize_map()
	GlobalSessionManager.run_progress = p
	GlobalSessionManager.started_session = true

	GlobalSceneLoader.load_scene(GlobalSceneLoader.MAP_SCENE_PATH)


func _on_start_new_clicked() -> void:
	GlobalSaveManager.reset()
	GlobalSessionManager.run_progress = null
	get_viewport().gui_disable_input = false
	GlobalSceneLoader.load_scene(GlobalSceneLoader.CHARACTER_GENERATOR_PATH)
	pass # Replace with function body.


func _on_return_clicked() -> void:
	visible = false
	main_menu.visible = true
	pass # Replace with function body.


func _on_delete_save_clicked() -> void:
	GlobalSaveManager.reset()
	GlobalSessionManager.run_progress = null
	get_viewport().gui_disable_input = false
	
	continue_button.set_disabled(true)
	delete_button.set_disabled(true)
	pass # Replace with function body.
