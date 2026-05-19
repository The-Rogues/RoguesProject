extends Resource
class_name MiniEventData

@export var map_texture: Texture2D
@export var repeatable:bool
@export var display_image:Texture2D
@export_multiline var scenario_text:String
@export var option_1_text:String
@export var option_2_text:String

@export_multiline var option_1_branch:Array[String] 
@export_multiline var option_2_branch:Array[String]

@export var option_1_condition:MiniEventCondition
@export var option_2_condition:MiniEventCondition

@export var option_1_accept_event:MiniEventResult = null
@export var option_2_accept_event:MiniEventResult = null
@export var option_1_result:MiniEventResult
@export var option_2_result:MiniEventResult 
