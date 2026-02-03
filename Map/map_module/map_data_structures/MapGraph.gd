# --MapGraph Class Script--
# Author: Fletcher Green

#------------------------------------------------------------------------------------
# Section: Declarations
#------------------------------------------------------------------------------------

extends RefCounted

# Nodes within the MapGraph are instanced from the MapGraphNode script.
var node_script: GDScript = preload("res://Map/map_module/map_data_structures/MapGraphNode.gd")

# A signal emitted whenever the data member holding the players position changes.
signal player_pos_changed(new_pos: RefCounted)

var node_arr: Array[RefCounted] # An array which will hold the MapGraph's individual nodes.
var map_layers: int # An integer which will hold the number of layers in the graph for quick reference.
var max_layer_nodes: int # An integer which will hold the largest number of nodes available to a single layer.
var player_pos: RefCounted: # A reference to the MapGraphNode that the player is currently located at.
	# This function is called whenever the player's position attempts to change.
	set(new_pos):
		if player_pos != new_pos:
			player_pos = new_pos # Set the new position if not already set.
			emit_signal("player_pos_changed", player_pos) # Emit the player_pos_changed signal.

#------------------------------------------------------------------------------------
# Section: _init Function
#------------------------------------------------------------------------------------

# --_init Function Description--
# Description: Uses a random seed to create a unique map structure. The function will
#              also eventually populate its MapGraphNodes with unique event data. 
#              Map height is determined by the number of mandatory nodes that the player
#              must cross, the number of intermediate layers leading to each mandatory node,
#              and an extra node that the player starts on. In terms of width, the 
#              generated graph uses the max layer size that it is given, with each layer
#              having between max_layer_sz and max_layer_sz - 3 nodes. Each node in the graph
#              is limited to have between one and three outgoing and incoming edges respectivley.
# Constraints: Do not set the max layer size bellow four without modifying the layer size weights.
#              For example, if the max layer size is three, you can get layers with zero nodes
#              since each layer has between max_layer_sz and max_layer_sz - 3 nodes.
# Algorithm:
#            1. Start at a single node. Make a new layer between size max_layer_sz 
#               and max_layer_sz - 3. Connect the starting node to each node in the new layer.
#            2. Make a new layer between size max_layer_sz and max_layer_sz - 3. Choose a random
#               side to prioritise (right or left). Connect the two outer nodes of whichever layer
#               is smaller to the outer nodes of the larger layer evenly on each side until the
#               larger layer's unconnected nodes are equal to the smaller layer's total nodes. If
#               an uneven numbar of connections must me made on a side, prioritise the random side
#               chosen earlier.
#            3. Define reference layer as the smaller of the two layers. Define inner nodes
#               as the nodes of the larger layer that were not connected in the previous step.
#               Record the number of connections made on each of the outer two nodes of the reference layer
#               respectivley.
#            4. Choose a random side to prioritise (right or left). Visit each node in the
#               reference layer starting at the prioritised side and ending at the unprioritised side.
#               Define the potential nodes each reference layer node can connect to by finding the node at
#               the corresponding position in the larger layer's inner nodes and its two neighbors.
#               Before connecting to potential nodes, determine if any potential connections were blocked
#               by the path of another connection and remove conflicting potential nodes. Then, choose randomly
#               to make between one and three connections to potential nodes, adjusting for connections
#               already made by the outer two nodes of the reference layer. Use as many connections as possible,
#               connecting to completley unvisited potential nodes first, and from the prioritised side
#               to the unprioritised side.
#            5. Repeat steps two through four for each intermediate layer added.
#            6. Connect all nodes in the final intermediate layer to a single node at the end of
#               the graph. If additional mandatory nodes are needed, repeat from step one treating
#               the end node as the start node.
# Return: void.
func _init(
	max_layer_sz: int, # The largest size a layer can be.
	layer_sz_weights: Array[float], # An array of four weights which add up to one. Smallest to largest. 
	out_edge_weights: Array[float], # An array of three weights that add up to one. Smallest to largest.
	int_layer_amnt: int, # The number of intermediate layers between each mandatory node.
	mandatory_node_amnt: int, # The number of mandatory nodes, excluding the starting node.
	map_seed: int # An integer which can be randomised to produce unique structures.
) -> void:
	
	# Init data member.
	max_layer_nodes = max_layer_sz
	
	# Create RandomNumberGernerator and give it the seed.
	var rand_gen = RandomNumberGenerator.new()
	rand_gen.seed = map_seed
	
	# Verify that the weights provided are valid without changing the array passed.
	var layer_sz_weights_valid: Array[float] = (
		func() -> Array[float]:
			if layer_sz_weights.size() != 4:
				return [0.25, 0.25, 0.25, 0.25]
			var weight_sum: float = 0
			for weight in layer_sz_weights:
				weight_sum += weight
			if weight_sum != 1.0 || layer_sz_weights.size() != 4:
				return [0.25, 0.25, 0.25, 0.25]
			return layer_sz_weights
	).call()
	
	# Verify that the weights provided are valid without changing the array passed.
	var out_edge_weights_valid: Array[float] = (
		func() -> Array[float]:
			if out_edge_weights.size() != 3:
				return [0.33, 0.33, 0.34]
			var weight_sum: float = 0
			for weight in out_edge_weights:
				weight_sum += weight
			if weight_sum != 1.0 || out_edge_weights.size() != 3:
				return [0.33, 0.33, 0.34]
			return out_edge_weights
	).call()
	
	# A helper function which sums the m=numbers in an array before the index provided.
	var sum_before: Callable = func(end_index: int, in_array: Array[float]) -> float:
		var ret_val: float = 0.0
		for i in range(0, end_index):
			ret_val += in_array[i]
		return ret_val
	
	# Helper functions to choose a number between one and three based on the 
	# edge weights provided.
	var get_random_edge_num: Callable = func() -> int:
		var rand_num: float = rand_gen.randf()
		if rand_num < sum_before.call(1, out_edge_weights_valid):
			return 1
		elif rand_num < sum_before.call(2, out_edge_weights_valid):
			return 2
		else:
			return 3
	
	# Helper function that randomly returns true or false.
	var coin_flip: Callable = func() -> bool:
		if rand_gen.randf() < 0.5:
			return false
		else:
			return true
	
	# Iterate for the number of mandatory nodes.
	var curr_layer: int = 0
	for i in range(0, mandatory_node_amnt):
		
		# The node before an intermediate layer is mandatory.
		var prev_layer_mandatory = true;
		
		# Add the starting node.
		if i == 0:
			node_arr.append(node_script.new(curr_layer))
			curr_layer += 1
		
		# Iterate for the number of intermediate layers between mandatory nodes.
		for j in range(0, int_layer_amnt):
			
			# Helper functions to choose a number between max_layer_sz and max_layer_sz - 3
			# based on the edge weights provided.
			var nodes_in_layer: int = (
				func() -> int:
					var rand_num: float = rand_gen.randf()
					if rand_num < sum_before.call(1, layer_sz_weights_valid):
						return max_layer_sz - 3
					elif rand_num < sum_before.call(2, layer_sz_weights_valid):
						return max_layer_sz - 2
					elif rand_num < sum_before.call(3, layer_sz_weights_valid):
						return max_layer_sz - 1
					else:
						return max_layer_sz
			).call()
			
			# Get the nodes that were in the previousley added layer.
			var prev_layer_nodes: Array[RefCounted] = []
			for k in range(0, node_arr.size()):
				if node_arr[k].node_layer == curr_layer - 1:
					prev_layer_nodes.append(node_arr[k])
			
			# Append new nodes to the main node array and save them in a second array to
			# represent the current layer.
			var curr_layer_nodes: Array[RefCounted]
			for k in range(0, nodes_in_layer):
				var new_node: RefCounted = node_script.new(curr_layer)
				node_arr.append(new_node)
				curr_layer_nodes.append(new_node)
			
			# --Algorithm Part Two: Connect Outer Nodes--
			#  Description: The bellow if branch corresponds to the second step of the algorithm.
			#               The if branch sets the four variables bellow, which are then used to determine
			#               the inner indices of the previous and current layers.
			var prev_layer_inner_indices: Array[int] # Will contain the first and last index of the inner nodes contained in the previous layer.
			var curr_layer_inner_indices: Array[int] # Will contain the first and last index of the inner nodes contained in the current layer.
			var reference_layer_existing_edges: Array[int] # A length two array that will contain the edges added in the second step on the reference layer's outer two nodes.
			var reference_layer_curr: bool = true # Flag that will be set to true if the reference layer is the current layer.
			
			# Branch executed if the previous node was mandatory. In this case, the previous layer
			# is connected to all nodes.
			if prev_layer_mandatory:
				
				for k in range(0, curr_layer_nodes.size()):
					connect_node(prev_layer_nodes[0], curr_layer_nodes[k])
				prev_layer_mandatory = false
				curr_layer += 1
				continue
				
			# Branch executed if the current layer is smaller than the previous layer.
			# Current layer becomes reference layer.
			elif prev_layer_nodes.size() > curr_layer_nodes.size():
				
				# Determine the difference in layer sizes and choose a random side to prioritise.
				var size_diff: int = prev_layer_nodes.size() - curr_layer_nodes.size()
				var prioritize_left: bool = coin_flip.call()
				
				# Connect outer nodes evenley at first. Ignore the remainder for now.
				for k in range(0, size_diff / 2):
					connect_node(prev_layer_nodes[k], curr_layer_nodes[0])
					connect_node(
						prev_layer_nodes[prev_layer_nodes.size() - 1 - k], 
						curr_layer_nodes[curr_layer_nodes.size() - 1]
					)
				
				# Branch executed if there was remainder and prioritise left.
				if (size_diff % 2 == 1) && prioritize_left:
					
					# Connect extra node to left side.
					connect_node(prev_layer_nodes[size_diff / 2], curr_layer_nodes[0])
					
					# Adjust for having one extra node on the left.
					prev_layer_inner_indices = [
						size_diff / 2 + 1,
						prev_layer_nodes.size() - 1 - (size_diff / 2)
					]
					reference_layer_existing_edges = [size_diff / 2 + 1, size_diff / 2]
					
				# Branch executed if there was remainder and prioritise right.
				elif size_diff % 2 == 1:
					
					# Connect extra node to right side.
					connect_node(
						prev_layer_nodes[prev_layer_nodes.size() - 1 - (size_diff / 2)], 
						curr_layer_nodes[curr_layer_nodes.size() - 1]
					)
					
					# Adjust for having one extra node on the right.
					prev_layer_inner_indices = [
						size_diff / 2,
						prev_layer_nodes.size() - 1 - ((size_diff / 2) + 1)
					]
					reference_layer_existing_edges = [size_diff / 2, size_diff / 2 + 1]
				
				# No remainder.
				else:
					
					# No side has to be adjusted for an extra node.
					prev_layer_inner_indices = [
						size_diff / 2,
						prev_layer_nodes.size() - 1 - (size_diff / 2),
					]
					reference_layer_existing_edges = [size_diff / 2, size_diff / 2]
				
				# Current layer is smaller, so its inner indices are itself.
				curr_layer_inner_indices = [0, curr_layer_nodes.size() - 1]
			
			# Branch executed if the previous layer is smaller than the previous layer.
			# Previous layer becomes reference layer.
			elif prev_layer_nodes.size() < curr_layer_nodes.size():
				
				# Determine the difference in layer sizes and choose a random side to prioritise.
				var size_diff: int = curr_layer_nodes.size() - prev_layer_nodes.size()
				var prioritize_left: bool = coin_flip.call()
				
				# Connect outer nodes evenley at first. Ignore the remainder for now.
				for k in range(0, size_diff / 2):
					connect_node(prev_layer_nodes[0], curr_layer_nodes[k])
					connect_node(
						prev_layer_nodes[prev_layer_nodes.size() - 1],
						curr_layer_nodes[curr_layer_nodes.size() - 1 - k]
					)
				
				# Branch executed if there was remainder and prioritise left.
				if (size_diff % 2 == 1) && prioritize_left:
					
					# Connect extra node to left side.
					connect_node(prev_layer_nodes[0], curr_layer_nodes[size_diff / 2])
					
					# Adjust for having one extra node on the left.
					curr_layer_inner_indices = [
						(size_diff / 2) + 1,
						curr_layer_nodes.size() - 1 - (size_diff / 2)
					]
					reference_layer_existing_edges = [(size_diff / 2) + 1, size_diff / 2]
				
				# Branch executed if there was remainder and prioritise right.
				elif size_diff % 2 == 1:
					
					# Connect extra node to right side.
					connect_node(
						prev_layer_nodes[prev_layer_nodes.size() - 1], 
						curr_layer_nodes[curr_layer_nodes.size() - 1 - (size_diff / 2)]
					)
					
					# Adjust for having one extra node on the right.
					curr_layer_inner_indices = [
						size_diff / 2,
						curr_layer_nodes.size() - 1 - ((size_diff / 2) + 1)
					]
					reference_layer_existing_edges = [size_diff / 2, (size_diff / 2) + 1]
				
				# No remainder.
				else:
					
					# No side has to be adjusted for an extra node.
					curr_layer_inner_indices = [
						size_diff / 2,
						curr_layer_nodes.size() - 1 - (size_diff / 2)
					]
					reference_layer_existing_edges = [size_diff / 2, size_diff / 2]
				
				# Reference layer is not curr_layer. Previous layer is smaller so its inner indices are itself.
				reference_layer_curr = false
				prev_layer_inner_indices = [0, prev_layer_nodes.size() - 1]
			
			# Executed if both layers are the same size. Both sets of inner indices are themselves.
			else:
				prev_layer_inner_indices = [0, curr_layer_nodes.size() - 1]
				curr_layer_inner_indices = [0, curr_layer_nodes.size() - 1]
				reference_layer_existing_edges = [0, 0]
			
			# --Algorithm Part Four: Connect Inner Nodes--
			#  Description: The bellow if branch connects the inner nodes of the array which correspond
			#               to each other. A slightly different sub-algorithm has to be used when
			#               connecting with respect to different refference layers.
			
			# Get array of inner indices for the current layer.
			curr_layer_nodes = curr_layer_nodes.slice(
				curr_layer_inner_indices[0],
				curr_layer_inner_indices[1] + 1
			)
			
			# Get array of inner indices for the previous layer.
			prev_layer_nodes = prev_layer_nodes.slice(
				prev_layer_inner_indices[0],
				prev_layer_inner_indices[1] + 1
			)
			
			# Executed if the reference layer is the current layer.
			if reference_layer_curr:
				
				# Choose random side to prioritise.
				var prioritize_left: bool = coin_flip.call()
				
				# If prioritising left start at the left side of the current layer and move right.
				# Else start right and move left.
				var loop_start: int = 0
				var loop_end: int = curr_layer_nodes.size()
				var loop_step: int = 1
				var potential_connections: Array[RefCounted] = [prev_layer_nodes[0]]
				if !prioritize_left:
					loop_start = curr_layer_nodes.size() - 1
					loop_end = -1
					loop_step = -1
					potential_connections = [prev_layer_nodes[prev_layer_nodes.size() - 1]]
				
				# Iterate over reference layer in decided direction.
				for k in range(loop_start, loop_end, loop_step):
					
					# When one position along the reference layer is moved, one new node is available to connect to.
					if !((k + loop_step) < 0) && !((k + loop_step) > (curr_layer_nodes.size() - 1)):
						potential_connections.append(prev_layer_nodes[k + loop_step])
					
					# Choose a random number of edges to add based on the weights.
					var add_edges: int = get_random_edge_num.call()
					
					# Adjust for existing edges on the outer two nodes of the reference layer.
					if k == 0:
						add_edges -= reference_layer_existing_edges[0]
					elif k == curr_layer_nodes.size() - 1:
						add_edges -= reference_layer_existing_edges[1]
					if add_edges < 1:
						add_edges = 1
					
					# --Connecting Inner Nodes in Reference to the Current Layer--
					# Description: Even though connection is accomplished in reference to the
					#              to the current layer, edges still have to originate from the
					#              previous layer. Because of this, the potential nodes in the 
					#              previous layer can be directly checked for existing edges.
					#              Nodes with no existing connections are connected on the first
					#              pass, in order. Nodes with existing connections are connected on the
					#              second pass, in order.
					for x in range(0, add_edges):
						
						# Loop over potential connections, connecting to the first available node
						# that has no connections.
						var found_connection: bool = false
						for y in range(0, potential_connections.size()):
							if potential_connections[y].node_edges.size() == 0:
								connect_node(
									potential_connections[y], 
									curr_layer_nodes[k]
								)
								# Flag set to avoid the second loop if a connection is found on the first pass.
								found_connection = true
								break
						if found_connection:
							continue
						
						# Connect to any potential node that is available, excluding nodes already connected to by the current node.
						for y in range(0, potential_connections.size()):
							if potential_connections[y].node_edges[
								potential_connections[y].node_edges.size() - 1
							] != curr_layer_nodes[k]:
								connect_node(
									potential_connections[y], 
									curr_layer_nodes[k]
								)
								break
					
					# A future connection has been blocked if the furthest potential connection
					# has a connection. In this case, the first potential connection of the next
					# reference node would have to cross the line from the current reference
					# node to the furthest current potential connection.
					if potential_connections[
						potential_connections.size() - 1
					].node_edges.size() > 0 && potential_connections.size() > 1:
						potential_connections.remove_at(potential_connections.size() - 2)
						if potential_connections.size() == 2:
							potential_connections.remove_at(0) # Out of range for the next refernce node.
					elif potential_connections.size() == 3:
						potential_connections.remove_at(0) # Out of range for the thext reference node.
			
			# Reference layer is previous layer.
			else:
				
				# Choose a random side to prioritise.
				var prioritize_left: bool = coin_flip.call()
				
				# If prioritising left start at the left side of the current layer and move right.
				# Else start right and move left.
				var loop_start: int = 0
				var loop_end: int = prev_layer_nodes.size()
				var loop_step: int = 1
				var potential_connections: Array[RefCounted] = [curr_layer_nodes[0]]
				if !prioritize_left:
					loop_start = prev_layer_nodes.size() - 1
					loop_end = -1
					loop_step = -1
					potential_connections = [curr_layer_nodes[curr_layer_nodes.size() - 1]]
				
				# Iterate over reference layer in decided direction.
				var first_iteration: bool = true # Flag to identify the first reference node in the sequence.
				for k in range(loop_start, loop_end, loop_step):
					
					# When one position along the reference layer is moved, one new node is available to connect to.
					if !((k + loop_step) < 0) && !((k + loop_step) > (curr_layer_nodes.size() - 1)):
						potential_connections.append(curr_layer_nodes[k + loop_step])
					
					# Get a random number of edges to add based on the specified weights.
					var add_edges: int = get_random_edge_num.call()
					
					# Adjust for existing edges on the outer two nodes of the reference layer.
					if k == 0:
						add_edges -= reference_layer_existing_edges[0]
					elif k == prev_layer_nodes.size() - 1:
						add_edges -= reference_layer_existing_edges[1]
					if add_edges < 1:
						add_edges = 1
					
					# --Connecting Inner Nodes in Reference to the Previous Layer--
					# Description: Since nodes only have outgoing edges, the number of connections
					#              going into a node on the current layer cannot be found by examining
					#              the node itself. Luckily, it is known that all of the nodes within
					#              the inner nodes of the current layer have no existing connections.
					#              Since each node on the current layer only has three possible nodes that
					#              can connect to it, it is known that incoming edges will be limited to three.
					var cut_off_next: bool = false
					for x in range(0, add_edges):
						if first_iteration: # The first reference node is guaranteed to connect to the potential node directly across.
							if x < potential_connections.size():
								connect_node(prev_layer_nodes[k], potential_connections[x])
								if x == potential_connections.size() - 1:
									cut_off_next = true  # Since the first node connects directly across, if it connects again it cuts off the next node.
						else:
							# The first potential node always already has a connection outside of the first iteration.
							# Because of this, connection is started from the second available node and the first node
							# is visited last.
							if (x + 1) == potential_connections.size():
								connect_node(prev_layer_nodes[k], potential_connections[0])
							elif (x + 1) < potential_connections.size():
								connect_node(prev_layer_nodes[k], potential_connections[x + 1])
								if (x + 1) == potential_connections.size() - 1:
									cut_off_next = true
					
					# If a node has been cut off, remove it from potential connections.
					if cut_off_next:
						potential_connections.remove_at(potential_connections.size() - 2)
						if potential_connections.size() == 2:
							potential_connections.remove_at(0) # Remove out of range node.
					elif potential_connections.size() == 3:
						potential_connections.remove_at(0) # Remove out of range node.
					
					# Turn off first iteration flag.
					first_iteration = false
			
			# Increment layer after adding an intermediate layer.
			curr_layer += 1
		
		# Append the mandatory node and connect all nodes in the previous layer to it.
		node_arr.append(node_script.new(curr_layer))
		curr_layer += 1
		for j in range(0, node_arr.size()):
			if node_arr[j].node_layer == (curr_layer - 2):
				connect_node(node_arr[j], node_arr[node_arr.size() - 1])
	
	# Set the players position to the first node and set the number of layers in the map.
	map_layers = node_arr[node_arr.size() - 1].node_layer + 1
	player_pos = node_arr[0]
	
	# Populate node event data member.
	populate_events()

#------------------------------------------------------------------------------------
# Section: Secondary Functions
#------------------------------------------------------------------------------------

# --connect_node Function--
# Description: Connects one node to another by adding to the node's adjacency list.
# in_node_1: The node to connect from.
# in_node_2: The node being connected to.
# Return: void.
func connect_node(in_node_1: RefCounted, in_node_2: RefCounted) -> void:
	var target_edges: Array[RefCounted] = in_node_1.node_edges
	for target_node in target_edges: # Check that the node is not already connected.
		if target_node == in_node_2:
			return
	target_edges.append(in_node_2)

# --get_layer Function--
# Description: Finds all nodes belonging to a given layer and returns them in an array.
# in_layer: An interger defining the layer of nodes to retreive.
# Return: An array of the nodes belonging to the specified layer.
func get_layer(in_layer: int) -> Array[RefCounted]:
	var ret_val: Array[RefCounted] = []
	for i in range(0, node_arr.size()):
		if node_arr[i].node_layer == in_layer:
			ret_val.append(node_arr[i])
		elif node_arr[i].node_layer > in_layer:
			break
	return ret_val

# --populate_events Function--
# Description: Logic for determining the distribution of events among MapGraphNodes.
#              To be finalised further into development.
# Return: void.
func populate_events() -> void:
	for i in range(0, node_arr.size()):
		if node_arr[i].node_layer % 2 == 0:
			node_arr[i].node_data = false # Even layered nodes are not battle nodes.
		else:
			node_arr[i].node_data = true # Odd layered nodes are battle nodes.
