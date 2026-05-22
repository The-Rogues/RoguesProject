# --MapInstance Scene Main Script--
# Author: Fletcher Green

#------------------------------------------------------------------------------------
# Section: Declarations
#------------------------------------------------------------------------------------

extends Control

# Scene describing the individual buttons on the map.
var map_button_scn: PackedScene = preload("res://Map/map_module/map_scenes/MapButton/MapButton.tscn")

# Textures to be used by MapButtons.
var texture_player: CompressedTexture2D = preload("res://test_art/player_position.png")
var texture_passed: CompressedTexture2D = preload("res://test_art/passed_position.png")

var map_buttons: Array[TextureButton] # Array to keep track of buttons that belong to the map instance.
var map_structure: RefCounted # Map structure is received in the init function, so the script does not need to be preloaded.

# The standard sizes for buttons in this instance.
var std_btn_size: Vector2
var special_btn_size: Vector2

# Variables for modulating navigable button sizes.
var elapsed_time: float = 0
var available_button_positions: Dictionary[TextureButton, Vector2]

# Variables for drawing map lines.
var vertical_dist: float = 0

#------------------------------------------------------------------------------------
# Section: Functions
#------------------------------------------------------------------------------------

# --init_map_instance Scene--
# Description: Creates map buttons and adds them as children. Connects the _on_map_button_pressed
#              function to each individual button's pressed signal. Calls the resize function to
#              fit the map to container size.
# Return: void.
func init_map_instance(
	in_struct: RefCounted, # Reference to the structural component of the map.
	container_size: Vector2, # Desired width and height.
	button_size: Vector2, # Desired button size.
) -> void:
	
	# Save a reference to the map's structural component.
	# Connect to the map structure's player_pos_changed component to update apearence of the
	# map when the player moves locations.
	map_structure = in_struct
	map_structure.player_pos_changed.connect(
		func(_ignore: RefCounted):
			set_button_states()
	)
	std_btn_size = button_size
	special_btn_size = std_btn_size + (std_btn_size / 2)
	
	# Create buttons that correspond to each MapGraphNode in the structural component.
	for i in range(0, map_structure.map_layers):
		var curr_layer: Array[RefCounted] = map_structure.get_layer(i)
		for j in range(0, curr_layer.size()):
			
			# Set button data members.
			var new_button = map_button_scn.instantiate()
			new_button.init_button(curr_layer[j], true)
			new_button.pressed.connect( # Connect every button's pressed signal to _on_map_button_pressed, emmiting the corresponding node.
				func():
					_on_map_button_pressed(new_button.corr_node)
			)
			add_child(new_button)
			new_button.texture_filter = TextureFilter.TEXTURE_FILTER_NEAREST
			new_button.ignore_texture_size = true
			new_button.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_CENTERED
			
			if curr_layer.size() == 1 && i != 0:
				# Make boss nodes bigger.
				new_button.is_std_sz = false
				new_button.custom_minimum_size = special_btn_size
				new_button.size = special_btn_size
			else:
				# Any othe nodes are normal size.
				new_button.custom_minimum_size = std_btn_size
				new_button.size = std_btn_size
			map_buttons.append(new_button)
	
	# Resize the map to the the dimensions requested and set initial button states.
	resize_map(container_size)
	set_button_states()

# --resize_map Function--
# Description: Sets the position of each button so that it fits within the specified container
#              dimensions. Calls the draw function to draw paths between each node.
# container_size: A vector containing desired map width and height.
# Return: Void.
func resize_map(container_size: Vector2) -> void:
	
	# 
	available_button_positions.clear()
	
	# Gets the vertical size of a path between nodes.
	var path_size = container_size.y - (std_btn_size.y * map_structure.map_layers + special_btn_size.y - std_btn_size.y)
	path_size /= map_structure.map_layers - 1
	
	var button_pos: int = 0 # Counts the number of buttons processed.
	var y_pos: float = container_size.y
	for i in range(0, map_structure.map_layers):
		
		y_pos -= std_btn_size.y
		
		# Iterate over the current layer.
		var curr_layer_size: int = map_structure.get_layer(i).size()
		for j in range(0, curr_layer_size):
			
			# Get the current button to process and anchor its postion relative to its parent.
			var curr_button: TextureButton = map_buttons[button_pos]
			anchor_button(curr_button)
			
			# Adjust the position of each button according to its layer and position within the layer.
			var left_increment: float = (container_size.x - std_btn_size.x) / (map_structure.max_layer_nodes - 1)
			curr_button.offset_left = ((container_size.x - std_btn_size.x) / 2) + (left_increment * j) - ((left_increment * (curr_layer_size - 1)) / 2)
			
			# First branch executes for outer nodes when layer size is max.
			var lmarg: float = container_size.x - std_btn_size.x - (left_increment * (curr_layer_size - 1))
			if ( (j == 0) || (j == curr_layer_size - 1) ) && curr_layer_size == map_structure.max_layer_nodes:
				if curr_button.corr_node.x_noise_left:
					curr_button.offset_left -= left_increment * curr_button.corr_node.x_noise_factor * 0.25
				else:
					curr_button.offset_left += left_increment * curr_button.corr_node.x_noise_factor * 0.25
			
			# Second branch executes for layers with a single node.
			elif (j == 0) && (j == curr_layer_size - 1):
				if curr_button.corr_node.x_noise_left:
					curr_button.offset_left -= lmarg * curr_button.corr_node.x_noise_factor * 0.10
				else:
					curr_button.offset_left += lmarg * curr_button.corr_node.x_noise_factor * 0.10
			
			# Executes only for left outer nodes.
			elif j == 0:
				if curr_button.corr_node.x_noise_left:
					curr_button.offset_left -= lmarg * curr_button.corr_node.x_noise_factor * 0.25
				else:
					curr_button.offset_left += left_increment * curr_button.corr_node.x_noise_factor * 0.25
			
			# Executes only for right outer nodes.
			elif j == curr_layer_size - 1:
				if curr_button.corr_node.x_noise_left:
					curr_button.offset_left -= left_increment * curr_button.corr_node.x_noise_factor * 0.25
				else:
					curr_button.offset_left += lmarg * curr_button.corr_node.x_noise_factor * 0.25
			
			# Executes for all other nodes.
			else:
				if curr_button.corr_node.x_noise_left:
					curr_button.offset_left -= left_increment * curr_button.corr_node.x_noise_factor * 0.25
				else:
					curr_button.offset_left += left_increment * curr_button.corr_node.x_noise_factor * 0.25
			
			# This barnch executes for boss nodes. Provides a small adjustment for the larger nodes.
			if  !curr_button.is_std_sz:
				y_pos -= special_btn_size.y - std_btn_size.y
				curr_button.offset_top = y_pos
			
			# Executes only for the starting node.
			elif curr_layer_size == 1 && i == 0:
				curr_button.offset_top = y_pos
			
			# Executes for intermediate nodes. 
			else:
				curr_button.offset_top = y_pos
				curr_button.offset_top += curr_button.corr_node.y_noise_factor * 0.3 * path_size
			
			# Next button in the array.
			button_pos += 1
			curr_button.resize()
		
		# New layers have a different y position.
		y_pos -= path_size
	
	vertical_dist = path_size
	
	# Draw lines between the buttons.
	queue_redraw()

# --anchor_button Function--
# Description: Anchors a button to the top left corner of its parent.
# in_button: The target button to anchor.
# Return: void.
func anchor_button(in_button: TextureButton) -> void:
	in_button.anchor_left = 0.0
	in_button.anchor_right = 0.0
	in_button.anchor_bottom = 0.0
	in_button.anchor_top = 0.0

# --set_button_states Function--
# Description: Sets the pressable and visual staes of all buttons based on the player's position.
# Return: void.
func set_button_states() -> void:
	
	# When found, this is set to whichever layer the player is on.
	# Before the player is found, the negative value tells that nodes are unavailable.
	var player_layer: int = -1
	
	# When the player's node is reached, the pressable buttons will be stored in this array.
	var accessable_buttons: Array[RefCounted] = []
	var room_in_progress :bool= GlobalSessionManager.run_progress != null and GlobalSessionManager.run_progress.room_in_progress
	var pending_index: int = -1
	var pending_layer: int = -1
	if room_in_progress:
		pending_index = GlobalSessionManager.run_progress.pending_node_index
		if pending_index >= 0 and pending_index < map_structure.node_arr.size():
			pending_layer = map_structure.node_arr[pending_index].node_layer
	
	for i in range(0, map_buttons.size()):
		
		# Disable all buttons by default.
		map_buttons[i].disabled = true
		
		## Set sub event texture if a sub event exists.
		#if map_buttons[i].corr_node.node_data.mini_event != null:
			#map_buttons[i].set_sub_texture(map_buttons[i].corr_node.node_data.mini_event.map_texture)
		
		# At player's position, set a unique texture and record accessable buttons.
		if map_buttons[i].corr_node == map_structure.player_pos:
			player_layer = map_structure.node_arr[i].node_layer
			accessable_buttons = map_structure.node_arr[i].node_edges.duplicate(true)
			map_buttons[i].texture_normal = texture_player
			map_buttons[i].texture_hover = texture_player
			map_buttons[i].hide_mini_event()
		
		# If the player's node has been found, this branch is executed.
		elif player_layer >= 0:
			
			# This top branch executes if the loop is still on the same layer as the player.
			if room_in_progress and i == pending_index:
				map_buttons[i].disabled = false
				map_buttons[i].texture_normal = map_buttons[i].corr_node.node_data.main_event.tex_ev_available
				map_buttons[i].texture_hover = map_buttons[i].corr_node.node_data.main_event.tex_ev_hover
					
			elif room_in_progress and map_structure.node_arr[i].node_layer == pending_layer:
				map_buttons[i].texture_normal = map_buttons[i].corr_node.node_data.main_event.tex_ev_unavailable
				map_buttons[i].texture_hover = map_buttons[i].corr_node.node_data.main_event.tex_ev_unavailable
					
			elif map_structure.node_arr[i].node_layer == player_layer:
				map_buttons[i].texture_normal = texture_passed
				map_buttons[i].texture_hover = texture_passed
				map_buttons[i].hide_mini_event()
			else:
				
				# Check if a button is accessable. If it is, make it pressable.
				if check_accessable(map_buttons[i].corr_node, accessable_buttons):
					map_buttons[i].disabled = false
					map_buttons[i].texture_normal = map_buttons[i].corr_node.node_data.main_event.tex_ev_available
					map_buttons[i].texture_hover = map_buttons[i].corr_node.node_data.main_event.tex_ev_hover
				
				# All other buttons are normal.
				else:
					map_buttons[i].texture_normal = map_buttons[i].corr_node.node_data.main_event.tex_ev_unavailable
					map_buttons[i].texture_hover = map_buttons[i].corr_node.node_data.main_event.tex_ev_unavailable
		else:
			if map_structure.visited_nodes.has(map_buttons[i].corr_node):
				map_buttons[i].texture_normal = map_buttons[i].corr_node.node_data.main_event.tex_ev_passed
				map_buttons[i].texture_hover = map_buttons[i].corr_node.node_data.main_event.tex_ev_passed
			else:
				# Set textures for passed nodes.
				map_buttons[i].texture_normal = texture_passed
				map_buttons[i].texture_hover = texture_passed
			map_buttons[i].hide_mini_event()


# --_draw Function--
# Description: Draws lines between related nodes. We will probably want to write a new function
#              later that draws fancier paths.
# Return: void.
func _draw() -> void:
	
	var path_map: Dictionary[RefCounted, RefCounted]
	for i in range(0, map_structure.visited_nodes.size() - 1):
		path_map[map_structure.visited_nodes[i]] = map_structure.visited_nodes[i + 1]
	
	# Record the position of each button.
	for i in range(0, map_structure.node_arr.size()):
		var curr_pos = Vector2(map_buttons[i].offset_left, map_buttons[i].offset_top)
		
		# For each adjacent button, record its position and draw a line between the two points.
		for j in range(0, map_structure.node_arr[i].node_edges.size()):
			var col: Color = Color.DARK_GRAY
			var adj_button = find_button_by_corr_node(map_structure.node_arr[i].node_edges[j])
			var adj_pos = Vector2(adj_button.offset_left, adj_button.offset_top)
			
			# Check if a path between two nodes has been traveled.
			if path_map.has(map_structure.node_arr[i]) && path_map[map_structure.node_arr[i]] == adj_button.corr_node:
				col = Color.BLUE
			
			# Draw a dotted line between the two positions.
			draw_dotted_line(
				curr_pos + (map_buttons[i].size / 2), # Exact position must be adjusted relative to button size.
				adj_pos + (adj_button.size / 2),
				col
			)

# --draw_dotted_line Function--
# Description: Draws a dotted line between two positions on the screen.
# pos_1: The first position to draw the line between.
# pos_2: The second position to draw the line between.
# Return: Void.
func draw_dotted_line(pos_1: Vector2, pos_2: Vector2, col: Color = Color.DARK_GRAY) -> void:
	
	# Create variables needed to make a series of evenly spaced vectors in a direction.
	var magnitude = sqrt((pos_1.x - pos_2.x) * (pos_1.x - pos_2.x) + (pos_1.y - pos_2.y) * (pos_1.y - pos_2.y)) # The length of the entire series of vectors.
	var direction = (pos_1 - pos_2) / magnitude # The direction of the sequence.
	var segment_size = vertical_dist / 5 # The size of an individual vector, including its margins.
	var num_segments = magnitude / segment_size # The number of vectors that fits into the entire magnitude.
	var small_segment_size = fmod(num_segments, 1.0) / 2 # The fractional part of the number of segments is converted into two small segments which will not be drawn.
	num_segments = (num_segments - (small_segment_size * 2)) + 2 # Adjust the total number of segments based on additional small segments.
	
	var curr_pos: Vector2 = pos_2 # Initialized to starting position.
	for i in range(0, int(num_segments)):
		
		# First segment is a small segment and is not drawn.
		if i == 0:
			curr_pos += direction * small_segment_size 
		
		# Last Segment is a small segment and is not drawn.
		elif i == (int(num_segments) - 1):
			return
		
		# Draw a line with 0.25 * segment_size margin starting at current position. Increment current position.
		else:
			draw_line(
				curr_pos + ((direction * segment_size) / 4), # Exact position must be adjusted relative to button size.
				curr_pos + ( ((direction * segment_size) / 4) * 3),
				col,
				std_btn_size.x / 20
			)
			curr_pos += direction * segment_size

# --find_button_by_corr_node Function--
# Description: Finds a specific button on the map given the structural node that it corresponds to.
# corr_node: Node that the button corresponds to in the map structure.
# Return: The specic texture button that contains the structural node within its corr_node data member.
func find_button_by_corr_node(corr_node: RefCounted) -> TextureButton:
	for i in range(0, map_buttons.size()):
		if corr_node == map_buttons[i].corr_node:
			return map_buttons[i]
	return # Returns nill if the node does not exist, which will cause an error. Make sure you know what you are doing.

# --check_accessable Function--
# Description: Checks the accessable_buttons array from the set_button_states function.
#              on finding an accessable button, it is removed from the array to slightly
#              improve efficiency.
# q_node: The node being examined for membership in accessable_buttons.
# access_arr: The array of accessable buttons.
# Return: True if found in the array, false if not.
func check_accessable(q_node: RefCounted, access_arr: Array[RefCounted]) -> bool:
	for i in range(0, access_arr.size()):
		if q_node == access_arr[i]:
			access_arr.remove_at(i)
			return true
	return false

# --_on_map_button_pressed Function--
# Description: When a map button is pressed it means that the player intends to move to that node.
#              This function changes the map structure's player node to the corresponding node of the button pressed.
# corr_node: The corresponding node of the button pressed.
# Return: Void.
func _on_map_button_pressed(corr_node: RefCounted) -> void:
	GlobalSessionManager.select_map_node(corr_node)
	available_button_positions.clear() # When the player's position is changed, new positions will be assigned to this map.

# --_process Function--
# Description: Modulates the sizes of naviagble buttons.
# delta: The time in seconds elapsed since the last function call.
# Return: Void.
func _process(delta: float) -> void:
	
	# Increment elapsed time.
	elapsed_time += delta
	
	# Get map nodes that are accessable from the map.
	var accessable_buttons: Array[RefCounted] = map_structure.player_pos.node_edges.duplicate(true)
	
	# Iterate over all map buttons.
	for i in range(0, map_buttons.size()):
		
		# Only change button size if its corresponding node is accessable.
		if check_accessable(map_buttons[i].corr_node, accessable_buttons):
			
			# If an accessable button's position has not been recorded it is recorded here.
			if !available_button_positions.has(map_buttons[i]):
				available_button_positions[map_buttons[i]] = map_buttons[i].position
			
			# Modulate button sizes using sine function.
			if map_buttons[i].is_std_sz:
				map_buttons[i].size = std_btn_size + std_btn_size * 0.1 * abs(sin(0.5 * elapsed_time * PI))
				map_buttons[i].position = available_button_positions[map_buttons[i]] - ( std_btn_size * 0.1 * abs(sin(0.5 * elapsed_time * PI)) ) / 2
			else:
				map_buttons[i].size = special_btn_size + special_btn_size * 0.1 * abs(sin(0.5 * elapsed_time * PI))
				map_buttons[i].position = available_button_positions[map_buttons[i]] - ( special_btn_size * 0.1 * abs(sin(0.5 * elapsed_time * PI)) ) / 2

# --get_vertical_offset Function--
# Description: Returns a vertical position bellow the current position button. This value will be used to set
#              the map screen's scroll bar to the correct height when it is losded.
# Return: A float value used to initialize the vertical position of the scroll bar on the map screen.
func get_vertical_offset() -> float:
	
	# Find the player's position and return a position 1.5 standard button sizes below it.
	for i in range(0, map_buttons.size()):
		if map_buttons[i].corr_node == map_structure.player_pos:
			return map_buttons[i].position.y + std_btn_size.y * 1.5
	
	# If the player's position is not found, retun zero.
	return 0.0
