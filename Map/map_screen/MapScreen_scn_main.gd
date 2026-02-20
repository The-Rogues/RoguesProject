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
			Vector2(0.0, 0.0), # Instance size does not matter as the map will be resized to fit its container in the init function.
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
	map_container.anchor_left = 0.0
	map_container.anchor_right = 0.0
	map_container.anchor_top = 0.0
	map_container.anchor_bottom = 1.0
	add_child(map_container) # Add the container as a child of the MapScreen.
	
	get_viewport().size_changed.connect(resize_map_container) # Make container resize with the screen.
	
	map_container.add_child(in_instance) # Make the MapInstance a child of the resizable container.
	
	# Make the MapInstance resize along with its parent.
	map_container.resized.connect(
		func():
			in_instance.resize_map(map_container.size)
	)
	resize_map_container() # Resize the container for initial display.
	in_instance.resize_map(map_container.size) # Resize the MapInstance for initial display. Should be handled by above function, but is not...

# --resize_map_container Function--
# Description: Centers the map container and makes it a ratio of the display size.
# Return: void.
func resize_map_container() -> void:
	map_container.offset_left = get_viewport().size.x / 4
	map_container.offset_right = (get_viewport().size.x / 4) * 3
