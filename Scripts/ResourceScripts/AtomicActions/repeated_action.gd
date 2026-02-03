extends AtomicAction
class_name RepeatedAction

# An Atomic action that queues multiple of the same action
@export_range(1,9) var times:int = 1
@export var action:AtomicAction

func execute(battle_info:BattleActionInfo):
	for i in range(times):
		battle_info.action_queue.enqueue(action, battle_info)
