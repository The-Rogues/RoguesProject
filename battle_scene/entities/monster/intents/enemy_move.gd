extends Resource
class_name EnemyMove

enum Type {ATTACK, OTHER}
@export var type:Type
@export var intent_icon:Texture2D
@export var name:String = "Unamed Move"
@export_multiline var description:String = "This Enemy intends to..."
@export var primary_action:Action
@export var secondary_action:Action


func get_actions() -> Array[Action]:
	var actions:Array[Action] = [primary_action]
	
	if secondary_action:
		actions.append(secondary_action)
	
	return actions
