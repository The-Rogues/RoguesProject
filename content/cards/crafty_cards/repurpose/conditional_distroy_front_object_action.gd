extends TargetedAction
class_name ConditionalDestroyFrontObjectAction

@export var conditional_action: Action = null

func execute(_context:BattleContext = null, _user:AbstractEntity = null):
	if _context.get_player().battle_position.get_object() != null:
		_context.get_player().battle_position.get_object().health.kill()
		if conditional_action:
			if conditional_action is TargetedAction:
				conditional_action.resolved_targets = resolved_targets
			await conditional_action.execute(_context, _user)
