# --EventData Resource Script--
# Author: Fletcher Green

#------------------------------------------------------------------------------------
# Section: Declarations
#------------------------------------------------------------------------------------

extends Resource
class_name EventData

@export var main_event: MainEventData # A map node's main event.
@export var mini_event: MiniEventData # A map node's mini event.
var mini_event_disabled: bool = false
