extends BattleAction
class_name RepeatAction

@export var battle_action:BattleAction
@export_range(1, 999) var repeat:int

func _execute(battle_instance:BattleManager, action_user:BattleEntity):
	battle_instance.action_queue.enqueue(
				battle_action, 
				battle_instance, 
				action_user
	)
	
	for i in range (1, repeat):
		var action_copy := battle_action.duplicate(true)
		if action_copy is TargetedBattleAction:
			action_copy.target = TargetedBattleAction.TargetType.INHERITED
			action_copy.targeting = battle_action.targeting
		
		battle_instance.action_queue.enqueue(
				battle_action, 
				battle_instance, 
				action_user
		)
