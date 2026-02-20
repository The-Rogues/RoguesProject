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
var texture_battle: CompressedTexture2D = preload("res://Map/map_module/map_assets/battle.png")
var texture_shop: CompressedTexture2D = preload("res://Map/map_module/map_assets/shop.png")
var texture_passed: CompressedTexture2D = preload("res://Map/map_module/map_assets/passed.png")

var map_buttons: Array[TextureButton] # Array to keep track of buttons that belong to the map instance.
var map_structure: RefCounted # Map structure is received in the init function, so the script does not need to be preloaded.

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
	
	# Create buttons that correspond to each MapGraphNode in the structural component.
	for i in range(0, map_structure.map_layers):
		var curr_layer: Array[RefCounted] = map_structure.get_layer(i)
		for j in range(0, curr_layer.size()):
			var new_button = map_button_scn.instantiate()
			new_button.init_button(curr_layer[j])
			new_button.pressed.connect( # Connect every button's pressed signal to _on_map_button_pressed, emmiting the corresponding node.
				func():
					_on_map_button_pressed(new_button.corr_node)
			)
			add_child(new_button)
			new_button.texture_filter = TextureFilter.TEXTURE_FILTER_NEAREST
			new_button.custom_minimum_size = button_size
			new_button.size = button_size
			map_buttons.append(new_button)
	
	# Resize the map to the the dimensions requested and set initial button states.
	resize_map(container_size)
	set_button_states()

# --resize_map Function--
# Description: Sets the position of each button so that it fits within the specified container
#              dimensions. Calls the draw function to draw paths between each node.
# container_size: A vector containing desired map width and height.
# Return: void.
func resize_map(container_size: Vector2) -> void:
	
	var button_pos: int = 0 # Counts the number of buttons processed.
	for i in range(0, map_structure.map_layers):
		
		# Iterate over the current layer.
		var curr_layer_size: int = map_structure.get_layer(i).size()
		for j in range(0, curr_layer_size):
			
			# Get the current button to process and anchor its postion relative to its parent.
			var curr_button: TextureButton = map_buttons[button_pos]
			anchor_button(curr_button)
			
			# Adjust the position of each button according to its layer and position within the layer.
			var left_increment: float = (container_size.x - curr_button.size.x) / (map_structure.max_layer_nodes - 1)
			curr_button.offset_left = ((container_size.x - curr_button.size.x) / 2) + (left_increment * j) - ((left_increment * (curr_layer_size - 1)) / 2)
			var top_increment: float = (container_size.y - curr_button.size.y) / (map_structure.map_layers - 1)
			curr_button.offset_top =  (container_size.y - curr_button.size.y) - (top_increment * i)
			button_pos += 1
	
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
					if map_structure.node_arr[i].node_data:
						map_buttons[i].texture_normal = texture_available_battle
						map_buttons[i].texture_hover = texture_available_battle_hover
					else:
						map_buttons[i].texture_normal = texture_available_shop
						map_buttons[i].texture_hover = texture_available_shop_hover
				
				# All other buttons are normal.
				else:
					if map_structure.node_arr[i].node_data:
						map_buttons[i].texture_normal = texture_battle
						map_buttons[i].texture_hover = texture_shop
					else:
						map_buttons[i].texture_normal = texture_shop
						map_buttons[i].texture_hover = texture_shop
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
