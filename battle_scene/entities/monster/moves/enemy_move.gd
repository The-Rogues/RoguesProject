@abstract
extends Resource
class_name EnemyMove

@export var intent_icon:Texture2D
@export var name:String = "Unamed Move"
@export_multiline var description:String = "This Enemy Intends to..."

@abstract
func get_actions() -> Array[Action]
