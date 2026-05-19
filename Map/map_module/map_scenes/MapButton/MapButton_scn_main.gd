# --MapButton Scene Main Script--
# Author: Fletcher Green

#------------------------------------------------------------------------------------
# Section: Declarations
#------------------------------------------------------------------------------------

extends TextureButton

# Get preassigned children.
@onready var sub_container: TextureRect = $TextureRect

var sub_visible: bool = true # Keeps track of the mini event icon's visibility.
var corr_node: RefCounted # The MapGraphNode that this button corresponds to.
var is_std_sz: bool # Marked as true if this button is the standard size of buttons on the map.
var elapsed_time: float = 0 # Time since the button was created used to modulate the sine function.

#------------------------------------------------------------------------------------
# Section: Functions
#------------------------------------------------------------------------------------

# --_ready Function--
# Description: Sets the sub event's texture and size if it exists.
# Return: Void.
func _ready() -> void:
	if corr_node.node_data.mini_event != null:
		sub_container.texture = corr_node.node_data.mini_event.map_texture
	sub_container.size = Vector2(self.size.x, self.size.y / 2)
	if sub_visible:
		sub_container.visible = true
	else:
		sub_container.visible = false

# --init_button Function--
# Description: Sets the corr_node data member. Reccomended that this is called directly after
#              instantiate.
# in_node: The node that the button corresponds to in the MapGraph structure.
# Return: Void.
func init_button(in_node: RefCounted, in_sz: bool) -> void:
	corr_node = in_node
	is_std_sz = in_sz

# --resize Function--
# Description: Resizes and positions the sub event based on the size of the parent. This is necessary for pulsing buttons.
# Return: Void.
func resize():
	if is_node_ready():
		sub_container.position = Vector2(self.size.x / 2, self.size.y / 2)
		sub_container.size = Vector2(self.size.x / 1.5, self.size.y / 1.5)

# --hide_mini_event Function--
# Description: Makes the mini event icon invisible.
# Return: Void.
func hide_mini_event() -> void:
	if is_node_ready():
		sub_container.visible = false
	sub_visible = false

# --show_mini_event Function--
# Description: Makes the mini event icon visible.
# Return: Void
func show_mini_event() -> void:
	if is_node_ready():
		sub_container.visible = false
	sub_visible = true

# --_process Function--
# Description: Modulates the opacity of the button's sub event and changes its size if necessary.
# Return: Void.
func _process(delta: float) -> void:
	elapsed_time += delta
	resize()
	sub_container.modulate.a = abs(sin(0.5 * elapsed_time * PI))
