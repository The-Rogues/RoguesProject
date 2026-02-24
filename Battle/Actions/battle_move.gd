extends Resource
class_name BattleMove

enum MoveType {PHYSICAL, SPECIAL}
@export var is_attack:bool = false
@export var action_display_icon:Texture2D
@export var move_type:MoveType
@export var name:String = "New battle move"
@export_multiline var description:String = "Deals x something..."
@export var actions:Array[BattleAction]

func get_total_damage():
	var total_damage:int = 0
	for action in actions:
		if action is DamageEntityAction:
			total_damage += action.damage
	return total_damage
