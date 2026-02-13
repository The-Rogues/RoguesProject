extends AtomicAction
class_name AddStatusConditionAction

@export var status_condition:StatusEffectData
@export var duration:int
@export var stack_count:int

func execute(action_context:ActionContext):
	for target in action_context.targets:
		target.add_status(status_condition, duration, stack_count)
	pass
