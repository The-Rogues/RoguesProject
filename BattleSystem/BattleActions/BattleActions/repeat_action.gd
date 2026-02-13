extends BattleAction
class_name RepeatAction

@export var battle_action:BattleAction
@export_range(1, 999) var repeat:int

func _execute(battle_instance:BattleManager, action_user:BattleEntity):
	for i in range (0, repeat):
		battle_instance.action_queue.enqueue(
				battle_action, 
				battle_instance, 
				action_user
		)
