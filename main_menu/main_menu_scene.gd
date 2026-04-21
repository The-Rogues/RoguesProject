extends Control
## Handles UI navigation for the main menu by toggling different elements as
## visible.
##
## Author: Nathaniel Stirret
## Editor: Fabian


@onready var title_screen: Control = $TitleScreen
@onready var save_screen: Control = $SaveScreen
@onready var options_menu: OptionsMenu = $OptionsMenu
@onready var credits_menu: Control = $CreditsMenu
@onready var close_menu: Control = $CloseMenu



func _ready() -> void:
	GlobalSessionInterface.visible = false
	
	title_screen.visible = true
	options_menu.visible = false
	credits_menu.visible = false
	close_menu.visible = false
	save_screen.visible = false
	options_menu.close.connect(show_main_menu)


func show_main_menu():
	title_screen.visible = true


func _on_start_clicked() -> void:
	title_screen.visible = false
	save_screen.visible = true



func _on_options_clicked() -> void:
	options_menu.visible = true
	title_screen.visible = false
	pass # Replace with function body.


func _on_credits_clicked() -> void:
	credits_menu.visible = true
	title_screen.visible = false
	pass # Replace with function body.




func _on_close_clicked() -> void:
	close_menu.visible = true
	title_screen.visible = false
	await get_tree().create_timer(3).timeout
	get_tree().quit()
	pass # Replace with function body.


func _on_close_credits_button_up() -> void:
	credits_menu.visible = false
	title_screen.visible = true
	pass # Replace with function body.
