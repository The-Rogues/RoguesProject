extends BattleAction
class_name RandomChanceAction

@export_range(0.1, 1) var chance:float = 0.5
@export var conditional_action:BattleAction
@export var otherwise_action:BattleAction

func _execute(battle_instance:BattleManager, action_user:BattleEntity):
	pass
	if randf() <= chance:
		battle_instance.action_queue.enqueue(
			conditional_action,
			battle_instance,
			action_user
		)
	else:
		battle_instance.action_queue.enqueue(
			otherwise_action,
			battle_instance,
			action_user
		)
