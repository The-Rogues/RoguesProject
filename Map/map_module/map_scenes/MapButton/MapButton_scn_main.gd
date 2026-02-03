# --MapButton Scene Main Script--
# Author: Fletcher Green

#------------------------------------------------------------------------------------
# Section: Declarations
#------------------------------------------------------------------------------------

extends TextureButton

# Every MapButton holds the node that it corresponds to in the MapGraph structure.
var corr_node: RefCounted

#------------------------------------------------------------------------------------
# Section: Functions
#------------------------------------------------------------------------------------

# --init_button Function--
# Description: Sets the corr_node data member. Reccomended that this is called directly after
#              instantiate.
# in_node: The node that the button corresponds to in the MapGraph structure.
# Return: void.
func init_button(in_node: RefCounted):
	corr_node = in_node
