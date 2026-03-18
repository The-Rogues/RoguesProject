# --MapButton Scene Main Script--
# Author: Fletcher Green

#------------------------------------------------------------------------------------
# Section: Declarations
#------------------------------------------------------------------------------------

extends TextureButton

# Every MapButton holds the node that it corresponds to in the MapGraph structure.
var corr_node: RefCounted
var sub_tex: CompressedTexture2D
@onready var sub_ev: TextureRect = $TextureRect

var is_std_sz: bool

#------------------------------------------------------------------------------------
# Section: Functions
#------------------------------------------------------------------------------------

func _ready() -> void:
	sub_ev.texture = sub_tex
	sub_ev.size = Vector2(self.size.x / 2, self.size.y / 2)
	#sub_ev.size = Vector2(self.size.x / 2, self.size.y / 2)
	#sub_ev.offset_left += self.size.x / 2
	#sub_ev.offset_top += self.size.y / 2
	#sub_ev.position += Vector2(self.size.x / 2, 0)

# --init_button Function--
# Description: Sets the corr_node data member. Reccomended that this is called directly after
#              instantiate.
# in_node: The node that the button corresponds to in the MapGraph structure.
# Return: void.
func init_button(in_node: RefCounted, in_sz: bool) -> void:
	corr_node = in_node
	is_std_sz = in_sz

func set_sub_texture(tex: CompressedTexture2D) -> void:
	sub_tex = tex

func resize():
	if is_node_ready():
		sub_ev.position = Vector2(self.size.x / 2, self.size.y / 2)
		sub_ev.size = Vector2(self.size.x / 2, self.size.y / 2)

var t: float = 0
func _process(delta: float) -> void:
	t += delta
	resize()
	sub_ev.modulate.a = abs(sin(0.5 * t * PI))
