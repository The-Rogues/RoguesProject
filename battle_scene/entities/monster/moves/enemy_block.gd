extends EnemyMove
class_name EnemyBlock

@export var block_action:BlockAction
@export var secondary_action:Action

func get_actions() -> Array[Action]:
	var actions:Array[Action] = [block_action]
	
	if secondary_action:
		actions.append(secondary_action)
	
	return actions
