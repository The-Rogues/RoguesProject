# --MapGraphNode Class Script--
# Author: Fletcher Green

#------------------------------------------------------------------------------------
# Section: Declarations
#------------------------------------------------------------------------------------

extends RefCounted

var node_edges: Array[RefCounted] # An array to hold adjacent nodes. Only holds outgoing edges.
var node_layer: int # An integer to hold the vertical layer that the map is on.
var node_data: bool # A placeholder variable to represent event data that the node will eventually hold.

#------------------------------------------------------------------------------------
# Section: Functions
#------------------------------------------------------------------------------------

# --_init Function--
# Description: Allows the node's layer to be initialised upon creation. Other data members
#              are filled at later points within the MapGraph's creation process. Called
#              automatically by the new function when instancing a MapGraphNode.
# in_layer: The integer to set the node's layer data member to.
# Return: void.
func _init(in_layer: int) -> void:
	node_layer = in_layer
