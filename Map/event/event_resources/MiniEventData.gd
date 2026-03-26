# --MainEventData Resource Script--
# Author: Fletcher Green

#------------------------------------------------------------------------------------
# Section: Declarations
#------------------------------------------------------------------------------------

extends Resource
class_name MiniEventData

@export var event_callback: Script # The callback executed when the mini event is activated.
@export var map_texture: CompressedTexture2D # The texture for the event diaplayed on the map.
@export var is_toggle: bool # If is_toggle is enable, the event can be toggled rather than a single activation.
@export var aes_texture: CompressedTexture2D # An image to display on the event screen, providing more context for the event.
@export var event_title: String # The tilte of the mini event.
@export_multiline var event_description: String # # A description of the mini event.
