# --MapScreen Main Scene--
# Author: Fletcher Green

#------------------------------------------------------------------------------------
# Section: Declarations
#------------------------------------------------------------------------------------

extends Control

@onready var scroll_container: ScrollContainer = $ScrollContainer # Container that will be used to scroll the map instance.

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
			Vector2(64.0, 64.0)
		)
	)
	
	MusicManager.change_song(MusicManager.track_list.choose_map_theme())

# --init_map_screen Function--
# Description: Displays a MapInstance centered on the screen and sets up screen resizing.
# in_instance: The map instance to diaplay on the screen. Refer to: res://Map/map_module/map_scenes/MapInstance/MapInstance_scn_main.gd
# Return: void.
func init_map_screen(in_instance: Control) -> void:
	
	# Anchor the scroll container to a set portion of the screen.
	scroll_container.anchor_left = 0.10
	scroll_container.anchor_right = 0.90
	scroll_container.anchor_top = 0.0
	scroll_container.anchor_bottom = 1.0
	
	# Set all offsets to zero.
	scroll_container.offset_left = 0.0
	scroll_container.offset_top = 0.0
	scroll_container.offset_right = 0.0
	scroll_container.offset_bottom = 0.0
	
	# Add a panel container as a child of the scroll container.
	var child_container: PanelContainer = PanelContainer.new()
	scroll_container.add_child(child_container)
	child_container.add_child(in_instance) # This is the container that will hold the map instance.
	
	# Make the child container anchored to the center of the screen.
	child_container.anchor_left = 0.5
	child_container.anchor_right = 0.5
	child_container.anchor_top = 0.5
	child_container.anchor_bottom = 0.5
	
	# Adjust the offsets so that the scroll container only takes up a third of the total panel container.
	child_container.offset_left = scroll_container.size.x / 2
	child_container.offset_right = scroll_container.size.x / 2
	child_container.offset_top =  scroll_container.size.y / 2
	child_container.offset_bottom = scroll_container.size.y * (5.0/2.0)
	child_container.custom_minimum_size = Vector2(scroll_container.size.x, scroll_container.size.y * 3)
	in_instance.resize_map(child_container.custom_minimum_size) # Resize the map to fill the child container.
	
	# Make the panel container's background black.
	var black_bg: StyleBoxFlat = StyleBoxFlat.new()
	black_bg.set("bg_color", Color(0.1, 0.1, 0.1))
	child_container.add_theme_stylebox_override("panel", black_bg)
	
	# Wait a frame so that the screen is properly sized.
	await get_tree().process_frame
	scroll_container.scroll_vertical = in_instance.get_vertical_offset() - scroll_container.size.y
	
	# Change the size of the panel container to match the new screen size.
	get_window().size_changed.connect(
		func():
			child_container.offset_left = scroll_container.size.x / 2
			child_container.offset_right = scroll_container.size.x / 2
			child_container.offset_top =  scroll_container.size.y / 2
			child_container.offset_bottom = scroll_container.size.y * (5.0/2.0)
			child_container.custom_minimum_size = Vector2(scroll_container.size.x, scroll_container.size.y * 3)
			in_instance.resize_map(child_container.custom_minimum_size)
	)
