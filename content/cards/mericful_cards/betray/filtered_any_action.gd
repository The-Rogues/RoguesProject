extends FilteredTargetedAction
class_name FilteredAnyAction

@export var action: Action

func execute(_context:BattleContext = null, _user:AbstractEntity = null):
	if action is TargetedAction:
		action.resolved_targets = resolved_targets
		action.ignore_foreground = ignore_foreground
	await action.execute(_context, _user)
