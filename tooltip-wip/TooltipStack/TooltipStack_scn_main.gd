extends Control

@onready var component_scn: PackedScene = preload("res://tooltip-wip/TooltipComponent/TooltipComponent.tscn") 

@onready var slf_container: VBoxContainer = $VBoxContainer

var slf_width = 0
var slf_margin = 0

var attack_index: int = 0
var ability_index: int = 0
var preference_index: int = 0

var group_names: Array[String]
var group_indices: Array[int]
var group_cols: Array # Pretending this is Array[Array[Color]]

func _ready():
	init_stack(200, 4)
	append_group("0", Color(1.0, 0.173, 0.0, 1.0), Color(1.0, 0.353, 0.216, 1.0), Color(0.729, 0.125, 0.0, 1.0))
	append_group("1", Color(0.639, 0.639, 0.639, 1.0), Color(0.58, 0.58, 0.58, 1.0), Color(0.369, 0.369, 0.369, 1.0))
	append_group("2", Color(0.11, 0.929, 0.369, 1.0), Color(0.204, 0.871, 0.416, 1.0), Color(0.086, 0.659, 0.267, 1.0))
	append_tooltip("0", load("res://Map/map_assets/battle.png"), "Group 0", "Sample text.")
	append_tooltip("1", load("res://Map/map_assets/battle.png"), "Group 1", "The quick brown fox jumped over the lazy dog.")
	append_tooltip("1", load("res://Map/map_assets/player.png"), "GROUP ONE", "Test.")
	append_tooltip("2", load("res://Map/map_assets/player.png"), "Group 2", "The Rogues.")
	clear_group("1")
	append_tooltip("1", load("res://Map/map_assets/battle.png"), "Group 1 Changed", "Changes have been made.")

func init_stack(
	in_width: int,
	in_margin: int
) -> void:
	slf_container.add_theme_constant_override("separation", 0)
	slf_width = in_width
	slf_margin = in_margin

func append_group(group_name: String, col_1: Color, col_2: Color, col_3: Color):
	if group_names.size() == 0:
		group_indices.append(0)
	else:
		group_indices.append(group_indices[group_indices.size() - 1])
	group_names.append(group_name)
	group_cols.append([col_1, col_2, col_3])

func append_tooltip(group_name: String, in_image: CompressedTexture2D, in_title: String, in_desc: String):
	var new_component = component_scn.instantiate()
	var group_index = index_by_group(group_name)
	slf_container.add_child(new_component)
	slf_container.move_child(new_component, group_indices[group_index])
	new_component.init_component(
		in_image,
		in_title,
		in_desc,
		slf_width,
		slf_margin,
		group_cols[group_index][0],
		group_cols[group_index][1],
		group_cols[group_index][2]
	)
	process_insertion(group_name)
	attach_new_callbacks(new_component, group_indices[group_index] - 1)

func clear_group(group_name: String):
	var group_index: int = index_by_group(group_name)
	var shift_amnt: int
	var lower_bound: int
	if group_index == 0:
		shift_amnt = group_indices[group_index]
		lower_bound = 0
	else:
		shift_amnt = group_indices[group_index] - group_indices[group_index - 1]
		lower_bound = group_indices[group_index - 1]
	for i in range(lower_bound, group_indices[group_index]):
		var curr_node = slf_container.get_child(0)
		slf_container.remove_child(curr_node)
		curr_node.queue_free()
	for i in range(group_index, group_names.size()):
		group_indices[i] -= shift_amnt
	clear_all_callbacks()
	attach_all_callbacks()

func index_by_group(in_name: String):
	for i in range(0, group_names.size()):
		if in_name == group_names[i]:
			return i

func process_insertion(in_name: String):
	var group_index = index_by_group(in_name)
	for i in range(group_index, group_indices.size()):
		group_indices[i] += 1

#func append_attack(
	#in_title: String,
	#in_description: String,
#) -> void:
	#var new_component = component_scn.instantiate()
	#slf_container.add_child(new_component)
	#slf_container.move_child(new_component, attack_index)
	#
	#new_component.init_component(
		#load("res://Map/map_assets/battle.png"),
		#in_title,
		#in_description,
		#slf_width,
		#slf_margin,
		#Color(1.0, 0.173, 0.0, 1.0),
		#Color(1.0, 0.353, 0.216, 1.0),
		#Color(0.729, 0.125, 0.0, 1.0)
	#)
	#
	#attack_index += 1
	#ability_index += 1
	#preference_index += 1
	#
	#attach_new_callbacks(new_component, attack_index - 1)
#
#func append_ability(
	#in_title: String,
	#in_description: String,
#) -> void:
	#var new_component = component_scn.instantiate()
	#slf_container.add_child(new_component)
	#slf_container.move_child(new_component, ability_index)
	#
	#new_component.init_component(
		#load("res://Map/map_assets/player.png"),
		#in_title,
		#in_description,
		#slf_width,
		#slf_margin,
		#Color(0.639, 0.639, 0.639, 1.0),
		#Color(0.58, 0.58, 0.58, 1.0),
		#Color(0.369, 0.369, 0.369, 1.0)
	#)
	#
	#ability_index += 1
	#preference_index += 1
	#
	#attach_new_callbacks(new_component, ability_index - 1)
#
#func append_preference(
	#in_title: String,
	#in_description: String,
#) -> void:
	#var new_component = component_scn.instantiate()
	#slf_container.add_child(new_component)
	#slf_container.move_child(new_component, preference_index)
	#
	#new_component.init_component(
		#load("res://Map/map_assets/availableboss.png"),
		#in_title,
		#in_description,
		#slf_width,
		#slf_margin,
		#Color(0.11, 0.929, 0.369, 1.0),
		#Color(0.204, 0.871, 0.416, 1.0),
		#Color(0.086, 0.659, 0.267, 1.0)
	#)
	#
	#preference_index += 1
	#
	#attach_new_callbacks(new_component, preference_index - 1)

func attach_new_callbacks(in_component: Control, in_index: int) -> void:
	for i in range(0, group_indices[group_indices.size() - 1]):
		if i != in_index:
			var curr_child: = slf_container.get_child(i)
			in_component.slf_dash.add_callback(
				func(_ignore):
					curr_child.collapse()
			)
			curr_child.slf_dash.add_callback(
				func(_ignore):
					in_component.collapse()
			)

func attach_all_callbacks() -> void:
	for i in range(0, group_indices[group_indices.size() - 1] - 1):
		for j in range(i + 1, group_indices[group_indices.size() - 1]):
			print(j)
			var curr_child = slf_container.get_child(i)
			var partner_child = slf_container.get_child(j)
			curr_child.slf_dash.add_callback(
				func(_ignore):
					partner_child.collapse()
			)
			partner_child.slf_dash.add_callback(
				func(_ignore):
					curr_child.collapse()
			)

func clear_all_callbacks() -> void:
	for i in range(0, group_indices[group_indices.size() - 1]):
		slf_container.get_child(i).reset_child_callbacks()

#func clear_attacks() -> void:
	#for i in range(0, attack_index):
		#var curr_node = slf_container.get_child(0)
		#slf_container.remove_child(curr_node)
		#curr_node.queue_free()
	#preference_index = preference_index - attack_index
	#ability_index = ability_index - attack_index
	#attack_index = 0
	#clear_all_callbacks()
	#attach_all_callbacks()
#
#func clear_abilities() -> void:
	#for i in range(attack_index, ability_index):
		#var curr_node = slf_container.get_child(attack_index)
		#slf_container.remove_child(curr_node)
		#curr_node.queue_free()
	#preference_index = preference_index - (ability_index - attack_index)
	#ability_index = attack_index
	#clear_all_callbacks()
	#attach_all_callbacks()
#
#func clear_preferences() -> void:
	#for i in range(ability_index, preference_index):
		#var curr_node = slf_container.get_child(ability_index)
		#slf_container.remove_child(curr_node)
		#curr_node.queue_free()
	#preference_index = ability_index
	#clear_all_callbacks()
	#attach_all_callbacks()
