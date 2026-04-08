extends EnemyMove
class_name EnemySpawn

@export var spawn_enemy_action:SpawnEnemyAction
@export var secondary_action:Action

func get_actions() -> Array[Action]:
	var actions:Array[Action] = [spawn_enemy_action]
	actions.append(secondary_action)
	
	return actions
