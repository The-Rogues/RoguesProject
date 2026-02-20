# --ShopScreen Main Script--
# Author: Fletcher Green

#------------------------------------------------------------------------------------
# Section: Declarations
#------------------------------------------------------------------------------------

extends Control

@onready var test_button: Button = $TestButton

#------------------------------------------------------------------------------------
# Section: Functions
#------------------------------------------------------------------------------------

# --_on_test_button_pressed Function--
# Description: Changes back to the map scene when the exit button is pressed.
# Return: void.
func _on_test_button_pressed() -> void:
	GlobalSceneLoader.load_scene("res://Map/map_screen/MapScreen.tscn")
