# Author: Nathaniel
# Edited: Fabian

# Handles screen navigation logic to access different elements of main menu
extends Node2D

@onready var main_menu: Control = $UILayer/Control/MainMenu
@onready var options_menu: OptionsMenu = $UILayer/Control/OptionsMenu
@onready var credits_menu: Control = $UILayer/Control/CreditsMenu
@onready var close_menu: Control = $UILayer/Control/CloseMenu

func _ready() -> void:
	main_menu.visible = true
	options_menu.visible = false
	credits_menu.visible = false
	close_menu.visible = false
	options_menu.close.connect(show_main_menu)

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
	GlobalSceneLoader.load_scene(GlobalSceneLoader.CHARACTER_CHANGER_SCREEN)
