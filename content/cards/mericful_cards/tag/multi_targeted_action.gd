extends TargetedAction
class_name MultiTargetedAction

@export var actions: Array[Action]

func execute(_context:BattleContext = null, _user:AbstractEntity = null):
	for i in range(0, actions.size()):
		if actions[i] is TargetedAction:
			actions[i].resolved_targets = resolved_targets
			actions[i].ignore_foreground = ignore_foreground
		await actions[i].execute(_context, _user)
