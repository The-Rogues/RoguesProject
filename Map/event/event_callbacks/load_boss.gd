# --load_boss Callback Script--
# Author: Fletcher Green

extends RefCounted

# For main events, write the code to load the new screen in this function.
# For mini events, write the code to execute in this function.
func process_event() -> void:
	GlobalSceneLoader.load_scene("res://Map/test_screen/TestScreen.tscn")
