extends AtomicAction
class_name ChanceAction
## Atomic action that uses RNG to decide of another [AtomicAction] is run
## Otherwise, queues a different [AtomicAction] if it is specified

## Sets an action to queue if rng chance is met
@export var conditional_action:AtomicAction
## Sets an action to queue if rng chance is not met
@export var consequence_action:AtomicAction
## Controls how likely the player is to recieve gold with higher values being
## closer to 100%
@export_range(0, 1) var chance:float

func execute(action_context:ActionContext):
	if randf() <= chance:
		action_context.action_queue.enqueue(conditional_action, action_context)
	else:
		if !consequence_action:
			return
		action_context.action_queue.enqueue(consequence_action, action_context)
