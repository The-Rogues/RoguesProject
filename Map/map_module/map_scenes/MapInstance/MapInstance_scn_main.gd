# --MapInstance Scene Main Script--
# Author: Fletcher Green

#------------------------------------------------------------------------------------
# Section: Declarations
#------------------------------------------------------------------------------------

extends Control

var map_button_scn: PackedScene = preload("res://Map/map_module/map_scenes/MapButton/MapButton.tscn")

# Textures to be used by MapButtons.
var texture_player: CompressedTexture2D = preload("res://Map/map_module/map_assets/player.png")
var texture_available_shop: CompressedTexture2D = preload("res://Map/map_module/map_assets/availableshop.png")
var texture_available_shop_hover: CompressedTexture2D = preload("res://Map/map_module/map_assets/availableshophover.png")
var texture_available_battle: CompressedTexture2D = preload("res://Map/map_module/map_assets/availablebattle.png")
var texture_available_battle_hover: CompressedTexture2D = preload("res://Map/map_module/map_assets/availablebattlehover.png")
var texture_available_boss: CompressedTexture2D = preload("res://Map/map_module/map_assets/availableboss.png")
var texture_available_boss_hover: CompressedTexture2D = preload("res://Map/map_module/map_assets/availablebosshover.png")
var texture_shop: CompressedTexture2D = preload("res://Map/map_module/map_assets/shop.png")
var texture_battle: CompressedTexture2D = preload("res://Map/map_module/map_assets/battle.png")
var texture_boss: CompressedTexture2D = preload("res://Map/map_module/map_assets/boss.png")
var texture_passed: CompressedTexture2D = preload("res://Map/map_module/map_assets/passed.png")
var texture_test: CompressedTexture2D = preload("res://Map/map_module/map_assets/test.png")

var map_buttons: Array[TextureButton] # Array to keep track of buttons that belong to the map instance.
var map_structure: RefCounted # Map structure is received in the init function, so the script does not need to be preloaded.

var std_btn_size: Vector2
var special_btn_size: Vector2

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
	
	nav_buttons.clear()
	
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
	for i in range(0, map_buttons.size()):
		
		# Disable all buttons by default.
		map_buttons[i].disabled = true
		
		if map_buttons[i].corr_node.node_data.mini_event != null:
			map_buttons[i].set_sub_texture(map_buttons[i].corr_node.node_data.mini_event.texture)
		
		# At player's position, set a unique texture and record accessable buttons.
		if map_buttons[i].corr_node == map_structure.player_pos:
			player_layer = map_structure.node_arr[i].node_layer
			accessable_buttons = map_structure.node_arr[i].node_edges.duplicate(true)
			map_buttons[i].texture_normal = texture_player
			map_buttons[i].texture_hover = texture_player
		
		# If the player's node has been found, this branch is executed.
		elif player_layer >= 0:
			
			# This top branch executes if the loop is still on the same layer as the player.
			if map_structure.node_arr[i].node_layer == player_layer:
				map_buttons[i].texture_normal = texture_passed
				map_buttons[i].texture_hover = texture_passed
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
			
			# Set textures for passed nodes.
			map_buttons[i].texture_normal = texture_passed
			map_buttons[i].texture_hover = texture_passed

# --_draw Function--
# Description: Draws lines between related nodes. We will probably want to write a new function
#              later that draws fancier paths.
# Return: void.
func _draw() -> void:
	
	# Record the position of each button.
	for i in range(0, map_structure.node_arr.size()):
		var curr_pos = Vector2(map_buttons[i].offset_left, map_buttons[i].offset_top)
		
		# For each adjacent button, record its position and draw a line between the two points.
		for j in range(0, map_structure.node_arr[i].node_edges.size()):
			var adj_button = find_button_by_corr_node(map_structure.node_arr[i].node_edges[j])
			var adj_pos = Vector2(adj_button.offset_left, adj_button.offset_top)
			draw_line(
				curr_pos + (map_buttons[i].size / 2), # Exact position must be adjusted relative to button size.
				adj_pos + (adj_button.size / 2),
				Color.WHITE
			)

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
# Return: void.
func _on_map_button_pressed(corr_node: RefCounted) -> void:
	map_structure.player_pos = corr_node
	nav_buttons.clear()

var t: float = 0
var nav_buttons: Dictionary[TextureButton, Vector2]
func _process(delta: float) -> void:
	t += delta
	var accessable_buttons: Array[RefCounted] = map_structure.player_pos.node_edges.duplicate(true)
	for i in range(0, map_buttons.size()):
		if check_accessable(map_buttons[i].corr_node, accessable_buttons):
			if !nav_buttons.has(map_buttons[i]):
				nav_buttons[map_buttons[i]] = map_buttons[i].position
			if map_buttons[i].is_std_sz:
				map_buttons[i].size = std_btn_size + std_btn_size * 0.1 * abs(sin(0.5 * (t * PI)))
				map_buttons[i].position = nav_buttons[map_buttons[i]] - ( std_btn_size * 0.1 * abs(sin(0.5 * (t * PI))) ) / 2
			else:
				map_buttons[i].size = special_btn_size + special_btn_size * 0.1 * abs(sin(0.5 * (t * PI)))
				map_buttons[i].position = nav_buttons[map_buttons[i]] - ( special_btn_size * 0.1 * abs(sin(0.5 * (t * PI))) ) / 2

func get_vertical_offset():
	for i in range(0, map_buttons.size()):
		if map_buttons[i].corr_node == map_structure.player_pos:
			return map_buttons[i].position.y + std_btn_size.y * 1.5
