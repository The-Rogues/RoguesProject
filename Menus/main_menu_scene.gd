extends Node2D
## Handles UI navigation for the main menu by toggling different elements as
## visible.
##
## Author: Nathaniel Stirret
## Editor: Fabian


@onready var main_menu: Control = $UILayer/Control/MainMenu
@onready var options_menu: OptionsMenu = $UILayer/Control/OptionsMenu
@onready var credits_menu: Control = $UILayer/Control/CreditsMenu
@onready var close_menu: Control = $UILayer/Control/CloseMenu
@onready var start_menu: Control = $UILayer/Control/StartMenu


func _ready() -> void:
	main_menu.visible = true
	options_menu.visible = false
	credits_menu.visible = false
	close_menu.visible = false
	start_menu.visible = false
	options_menu.close.connect(show_main_menu)


func show_main_menu():
	main_menu.visible = true


func _on_start_clicked() -> void:
	main_menu.visible = false
	start_menu.visible = true


func _on_quit_button_up() -> void:
	close_menu.visible = true
	main_menu.visible = false
	await get_tree().create_timer(3).timeout
	get_tree().quit()


func _on_credits_button_up() -> void:
	credits_menu.visible = true
	main_menu.visible = false


func _on_go_back_credits_button_up() -> void:
	credits_menu.visible = false
	main_menu.visible = true


func _on_options_button_up() -> void:
	options_menu.visible = true
	main_menu.visible = false
