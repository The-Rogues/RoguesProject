extends AtomicAction
class_name RepeatedAction

## AtomicAction that queues a selected action a specified number of times.
##
## Identical to having multiple of the same atomic action actions in a
## combat move. Created to make queing repeated actions convenient and
## compact.

## Controls the number of times the action will be queued
@export_range(2,99) var times:int = 1
## Specifies the action to queue
@export var action:AtomicAction


func execute(action_context:ActionContext):
	for i in range(times):
		action_context.action_queue.enqueue(action, action_context)
