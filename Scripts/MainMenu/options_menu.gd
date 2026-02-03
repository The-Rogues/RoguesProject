# Author: Nathaniel
# Editor: Fabian

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
