# --MapManager Class Script--
# Author: Fletcher Green

#------------------------------------------------------------------------------------
# Section: Declarations
#------------------------------------------------------------------------------------

extends RefCounted
class_name MapManager

# Manages a single map structure and creates visual instances of the structure.
var map_structure_script: GDScript = preload("res://Map/map_module/map_data_structures/MapGraph.gd")
var map_instance_scene: PackedScene = preload("res://Map/map_module/map_scenes/MapInstance/MapInstance.tscn")

var map_structure: RefCounted

#------------------------------------------------------------------------------------
# Section: Functions
#------------------------------------------------------------------------------------

# --_init Function--
# Description: Initialises the map's structure using defined settings and a provided seed.
# map_seed: An integer that serves as a random seed for the map generated.
# Return: void.
func _init(map_seed: int) -> void:
	map_structure = map_structure_script.new(
		6,
		[0.10, 0.10, 0.40, 0.40] as Array[float],
		[0.75, 0.15, 0.10] as Array[float],
		10,
		1,
		map_seed
	)

# --get_new_map_instance Function--
# Description: Creates a map instance scene based on the existing structural map component.
# container_size: Should be set to the width and height of the map's intended parent, but does not have to.
# btn_size: The button width and height should be the same.
# Return: A MapInstance scene which can be displayed on the screen.
#         Refer to the code for specific functionality: res://map_module/map_scenes/MapInstance/MapInstance_scn_main.gd.
func get_new_map_instance(
	container_size: Vector2,
	btn_size: Vector2
) -> Control:
	var ret_val: Control = map_instance_scene.instantiate()
	ret_val.init_map_instance(
		map_structure,
		container_size,
		btn_size
	)
	return ret_val

# --add_callback Function--
# Description: Connects a callback function to the map manager. Whenever the position of the
#              player changes, the callback is called and supplied with the new position MapGraphNode.
# callback_func: A callable that takes RefCounted as input. Refer to the MapGraphNode script for
#                the unique data members that you can expect: res://map_module/map_data_structures/MapGraphNode.gd.
# Return: void.
func add_callback(callback_func: Callable) -> void:
	map_structure.player_pos_changed.connect(
		func(emmited_node: RefCounted):
			callback_func.call(emmited_node)
	)
