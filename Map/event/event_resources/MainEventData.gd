# --MainEventData Resource Script--
# Author: Fletcher Green

#------------------------------------------------------------------------------------
# Section: Declarations
#------------------------------------------------------------------------------------

extends Resource
class_name MainEventData

@export var event_callback: Script # The callback executed to load the event.
@export var tex_ev_unavailable: CompressedTexture2D # The texture displayed when the event is unavailable.
@export var tex_ev_available: CompressedTexture2D # The texture diaplayed when the event is available.
@export var tex_ev_hover: CompressedTexture2D # The texture displayed when the event is available and the user hovers over it.
@export var tex_ev_passed: CompressedTexture2D
