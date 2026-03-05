# --MapScreen Main Scene--
# Author: Fletcher Green

#------------------------------------------------------------------------------------
# Section: Declarations
#------------------------------------------------------------------------------------

extends Control

var map_container: PanelContainer # Container that will be used to resize the map instance.

#------------------------------------------------------------------------------------
# Section: Functions
#------------------------------------------------------------------------------------

# --_ready Function--
# Description: Gets an instance of the map from the global MapManager and uses it to 
#              initialise the map screen.
# Return: void.
func _ready() -> void:
	init_map_screen(
		GlobalSessionManager.run_progress.run_map.get_new_map_instance(
			Vector2(0.0, 0.0), # Instance size does not matter as the map will be resized to fit its container after the init function.
			Vector2(32.0, 32.0)
		)
	)

# --init_map_screen Function--
# Description: Displays a MapInstance centered on the screen and sets up screen resizing.
# in_instance: The map instance to diaplay on the screen. Refer to: res://Map/map_module/map_scenes/MapInstance/MapInstance_scn_main.gd
# Return: void.
func init_map_screen(in_instance: Control) -> void:
	
	# Anchor the container to the top left corner but make its height always the same as
	# the screen height.
	map_container = PanelContainer.new()
	add_child(map_container) # Add the container as a child of the MapScreen.
	
	map_container.anchor_left = 0.25
	map_container.anchor_right = 0.75
	map_container.anchor_top = 0.0
	map_container.anchor_bottom = 1.0
	
	get_window().size_changed.connect(
		func():
			in_instance.resize_map(map_container.size)
	)
	
	map_container.add_child(in_instance) # Make the MapInstance a child of the resizable container.
	
	# Resize the map instance. I don't know why, but this only works when the
	# function is called twice. -_-
	in_instance.resize_map(map_container.size)
	in_instance.resize_map(map_container.size)
