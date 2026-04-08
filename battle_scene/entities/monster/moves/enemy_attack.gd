extends EnemyMove
class_name EnemyAttack

@export var attack_action:RandomAttackAction
@export var secondary_action:Action

func get_actions() -> Array[Action]:
	var actions:Array[Action] = [attack_action]
	
	if secondary_action:
		actions.append(secondary_action)
	
	return actions
