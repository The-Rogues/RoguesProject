extends FilteredTargetedAction
class_name SpareAction

func execute(_context:BattleContext = null, _user:AbstractEntity = null):
	for i in range(resolved_targets.size() - 1, -1, -1):
		if !resolved_targets[i]:
			continue
		
		resolved_targets[i].health.kill()
		await action_resolve_delay()
