extends EnemyMove
class_name EnemyStatusEffect

@export var status_effect_action:ApplyStatusAction

func get_actions() -> Array[Action]:
	return [status_effect_action] as Array[Action]
