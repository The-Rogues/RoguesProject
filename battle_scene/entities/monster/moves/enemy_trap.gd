extends EnemyMove
class_name EnemyTrap

@export var effect_action:ApplyPositionEffectAction
@export var secondary_action:Action


func get_actions() -> Array[Action]:
	var actions:Array[Action] = [effect_action]
	
	if secondary_action:
		actions.append(secondary_action)
	
	return actions
