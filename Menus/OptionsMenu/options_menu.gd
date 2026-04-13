# Author: Nathaniel
# Editor: Fabian, Andy 

# Will be used to update an options resource which will configure
# different technical elements of the game

extends Control
class_name OptionsMenu

signal close

@onready var resolution_options: OptionButton = $OptionsMenuElements/MarginContainer/TabContainer/Graphics/Resolution/Options
@onready var accessability_check_box: CheckBox = $OptionsMenuElements/MarginContainer/TabContainer/Accessability/VBoxContainer/CheckBox
@onready var master_volume: HSlider = $OptionsMenuElements/MarginContainer/TabContainer/Audio/VBoxContainer/HBoxContainer/MasterVolume
@onready var configuration: LineEdit = $OptionsMenuElements/MarginContainer/TabContainer/Controls/VBoxContainer/HBoxContainer/Configuration


func _on_go_back_button_up() -> void:
	visible = false
	close.emit()
	pass # Replace with function body.

# TODO: Connect signals for each settings uption to a function that updates a
# options resource, which will be used to configure systems


#When main menu button is pressed the scene tree changes to the main menu scene and deletes the current one. 
func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://Menus/MainMenu/main_menu_scene.tscn")


#As the volumne slide is changed it affects the music bus 
func _on_music_slider_value_changed(value: float) -> void:
	MusicManager.set_music_volume(value)
	
	#Change the value of the music bus 

#How does this work? There is no literal signal here rn? 
func _on_settings_pressed() -> void:
	visible = true
  

func _on_master_volume_value_changed(value: float) -> void:
	MusicManager.set_master_volume(value)


func _on_music_on_off_toggled(toggled_on: bool) -> void:
	MusicManager.set_music_enabled(toggled_on)
