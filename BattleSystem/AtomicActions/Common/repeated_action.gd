# ==========================================================
# Author: Fabian 
# Description:
#   An editable resource that queues a passed AtomicAction 
#   a specified number of times.
#   Useful for repeated attacks like hit target 3-times
#   which can be checked by some event system to trigger an effect
#   To be used as a creatable asset in paramater fields of CombatMove.
#
# ==========================================================

extends AtomicAction
class_name RepeatedAction

# Times to queue the action
@export_range(1,9) var times:int = 1
@export var action:AtomicAction

func execute(action_context:ActionContext):
	for i in range(times):
		action_context.action_queue.enqueue(action, action_context)
