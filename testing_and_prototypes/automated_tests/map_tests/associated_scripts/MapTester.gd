# --MapTester Class Script--
# Author: Fletcher Green

#------------------------------------------------------------------------------------
# Section: Declarations
#------------------------------------------------------------------------------------

extends RefCounted
class_name MapTester

#------------------------------------------------------------------------------------
# Section: Traversal Functions
#------------------------------------------------------------------------------------

# --test_map_traversal Function--
# Description: Sets up the recursive traversal function with the given map structure.
# in_structure: MapGraph to test for traversability.
# Return: True if the test was passed, false if not.
static func test_map_traversal(in_structure: RefCounted) -> bool:
	
	# Set up the recursive traversal function with the proper inputs.
	var test_res: bool = map_traversal_recursive(
		in_structure.node_arr[in_structure.node_arr.size() - 1],
		in_structure.node_arr[0],
		-1
	)
	
	# Return true or false based on the return value of the recursive traversal function.
	if test_res:
		return true
	else:
		return false

# --test_map_traversal Function--
# Description: Checks that each node is connected to a nodes only one layer above it.
#              Returns true when the final node in the graph is reached.
# end_node: The graph's final node, which stops the function upon being reached.
# target_node: The current node on the path being traversed. Each of its outgoung edges must be recursivley checked.
# prev_layer: The layer of the adjacent node whose path was followed to reach the target node.
# Return: True if the test was passed, false if not.
static func map_traversal_recursive(end_node: RefCounted, target_node: RefCounted, prev_layer: int) -> bool:
	
	if target_node == end_node:
		return true # Break out of recursion and return true when the end node is reached.
	elif target_node.node_layer != (prev_layer + 1):
		return false # Break out of recursion and return false when layers are not connected as expected.
	
	# Repeat this process for each adjacent node.
	for i in range(0, target_node.node_edges.size()):
		if !map_traversal_recursive(end_node, target_node.node_edges[i], target_node.node_layer):
			return false # If false is ever received pass it down the call stack.
	return true # If reached, all paths can be traversed as expected..

#------------------------------------------------------------------------------------
# Section: Traversal Functions
#------------------------------------------------------------------------------------

# --test_map_structure Function--
# Description: Tests that the map's structure is as expected. This includes every intermediate node having
#              less than three outgoing edges, less than three incoming edges, and proper event distribution accross
#              all nodes.
# in_structure: The map structure to be tested by the function.
# Return: True if the automated test is passed, false if failed.
static func test_map_structure(in_structure: RefCounted):
	
	# Create variables to track structural information.
	var max_outgoing_edges: int = 0
	var max_incoming_edges: int = 0
	var is_distribution_as_expected: bool = true
	var curr_layer: int = 0
	var is_battle_layer: bool = false
	
	var battle_data: Resource = load("res://Map/event/event_instances/battle_event_data.tres")
	var shop_data: Resource = load("res://Map/event/event_instances/shop_event_data.tres")
	var boss_data: Resource = load("res://Map/event/event_instances/boss_event_data.tres")
	
	# Create a dictionry and initialise all pages that will be used to zero.
	var in_edge_count_dict: Dictionary[RefCounted, int] = {}
	for i in range(1, in_structure.node_arr.size()):
		in_edge_count_dict[in_structure.node_arr[i]] = 0
	
	# Iterare over all nodes except the first and last.
	for i in range(1, in_structure.node_arr.size() - 1):
		
		# If the layer changes, the expected event distribution on that layer also changes.
		if in_structure.node_arr[i].node_layer != curr_layer:
			curr_layer = in_structure.node_arr[i].node_layer
			is_battle_layer = !is_battle_layer
		
		# Record size of node incoming edges unless one layer from the final node.
		if curr_layer != in_structure.node_arr[in_structure.node_arr.size() - 1].node_layer - 1:
			for j in range(0, in_structure.node_arr[i].node_edges.size()):
				in_edge_count_dict[in_structure.node_arr[i].node_edges[j]] += 1
		
		# Check for a new largest number of outgoing edges.
		if in_structure.node_arr[i].node_edges.size() > max_outgoing_edges:
			max_outgoing_edges = in_structure.node_arr[i].node_edges.size()
	
	var test_path: Callable = func(test_node: RefCounted, node_type: RefCounted, battle_layer: bool, slf: Callable):
		if test_node == in_structure.node_arr[in_structure.node_arr.size() - 1]:
			return true
		if battle_layer:
			if test_node.node_data.main_event != battle_data:
				return false
			else:
				for i in range(0, test_node.node_edges.size()):
					if !slf.call(test_node.node_edges[i], null, false, slf):
						return false
					return true
		elif node_type == null:
			if test_node.node_data.main_event == battle_data:
				for i in range(0, test_node.node_edges.size()):
					if !slf.call(test_node.node_edges[i], shop_data, false, slf):
						return false
					return true
			else:
				for i in range(0, test_node.node_edges.size()):
					if !slf.call(test_node.node_edges[i], battle_data, false, slf):
						return false
					return true
		else:
			if node_type == battle_data:
				if test_node.node_data.main_event != battle_data:
					return false
			else:
				if test_node.node_data.main_event == battle_data:
					return false
			for i in range(0, test_node.node_edges.size()):
				if !slf.call(test_node.node_edges[i], null, true, slf):
					return false
				return true
	
	for i in range(0, in_structure.node_arr[0].node_edges.size()):
		var curr_node: RefCounted = in_structure.node_arr[0].node_edges[i]
		if curr_node.node_data.main_event != battle_data:
			is_distribution_as_expected = false
		for j in range(0, curr_node.node_edges.size()):
			is_distribution_as_expected = test_path.call(curr_node.node_edges[j], null, false, test_path)
			
	if in_structure.node_arr[in_structure.node_arr.size() - 1].node_data.main_event != boss_data:
		is_distribution_as_expected = false
	
	# Print an error message if map structure is not as expected.
	if max_outgoing_edges > 3 || max_incoming_edges > 3 || !is_distribution_as_expected:
	
		print("MAP STRUCTURAL ERROR:")
		print("Largest number of outgoing edges: ", max_outgoing_edges)
		print("Largest number of incoming edges: ", max_incoming_edges)
		if is_distribution_as_expected:
			print("Event Distribution as expected.")
		else:
			print("Event distribution not as expected.")
		
		return false
	
	return true
