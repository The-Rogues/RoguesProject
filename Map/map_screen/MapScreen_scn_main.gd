# --MapScreen Main Scene--
# Author: Fletcher Green

#------------------------------------------------------------------------------------
# Section: Declarations
#------------------------------------------------------------------------------------

extends Control

@onready var scroll_container: ScrollContainer = $ScrollContainer# Container that will be used to resize the map instance.
var map_container: PanelContainer
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

# --init_map_screen Function--
# Description: Displays a MapInstance centered on the screen and sets up screen resizing.
# in_instance: The map instance to diaplay on the screen. Refer to: res://Map/map_module/map_scenes/MapInstance/MapInstance_scn_main.gd
# Return: void.
func init_map_screen(in_instance: Control) -> void:
	
	scroll_container.anchor_left = 0.10
	scroll_container.anchor_right = 0.90
	scroll_container.anchor_top = 0.0
	scroll_container.anchor_bottom = 1.0
	
	scroll_container.offset_left = 0.0
	scroll_container.offset_top = 0.0
	scroll_container.offset_right = 0.0
	scroll_container.offset_bottom = 0.0
	
	
	var child_cont: PanelContainer = PanelContainer.new()
	scroll_container.add_child(child_cont)
	child_cont.add_child(in_instance)
	
	child_cont.anchor_left = 0.5
	child_cont.anchor_right = 0.5
	child_cont.anchor_top = 0.5
	child_cont.anchor_bottom = 0.5
	
	#await get_tree().process_frame
	
	child_cont.offset_left = scroll_container.size.x / 2
	child_cont.offset_right = scroll_container.size.x / 2
	child_cont.offset_top =  scroll_container.size.y / 2
	child_cont.offset_bottom = scroll_container.size.y * (5.0/2.0)
	child_cont.custom_minimum_size = Vector2(scroll_container.size.x, scroll_container.size.y * 3)
	in_instance.resize_map(child_cont.custom_minimum_size)
	
	var black_bg: StyleBoxFlat = StyleBoxFlat.new()
	black_bg.set("bg_color", Color(0.1, 0.1, 0.1))
	child_cont.add_theme_stylebox_override("panel", black_bg)
	
	
	await get_tree().process_frame
	scroll_container.scroll_vertical = in_instance.get_vertical_offset() - scroll_container.size.y
	
	
	get_window().size_changed.connect(
		func():
			child_cont.offset_left = scroll_container.size.x / 2
			child_cont.offset_right = scroll_container.size.x / 2
			child_cont.offset_top =  scroll_container.size.y / 2
			child_cont.offset_bottom = scroll_container.size.y * (5.0/2.0)
			child_cont.custom_minimum_size = Vector2(scroll_container.size.x, scroll_container.size.y * 3)
			in_instance.resize_map(child_cont.custom_minimum_size)
	)
