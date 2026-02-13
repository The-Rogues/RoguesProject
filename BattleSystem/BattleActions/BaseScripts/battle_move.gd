extends Resource
class_name BattleMove

enum MoveType {PHYSICAL, SPECIAL}
@export var action_display_icon:Texture2D
@export var move_type:MoveType
@export var name:String = "New battle move"
@export_multiline var description:String = "Deals x something..."
@export var actions:Array[BattleAction]
