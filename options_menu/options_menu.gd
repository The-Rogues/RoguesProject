# Author: Nathaniel
# Editor: Fabian, Andy 

# Will be used to update an options resource which will configure
# different technical elements of the game

extends Control
class_name OptionsMenu

@onready var settings_menu: PanelContainer = $SettingsMenu
@onready var tutorial_button: Button = %Tutorial

func open_settings_directly() ->void:
	visible = true
	settings_menu.visible = true
	pass

func _on_settings_button_up() -> void:
	settings_menu.visible = true
	pass # Replace with function body.


func _on_main_menu_button_up() -> void:
	visible = false
	GlobalSceneLoader.load_scene(GlobalSceneLoader.MAIN_MENU_PATH)
	pass # Replace with function body.


func _on_close_button_up() -> void:
	visible = false
pass # Replace with function body.
