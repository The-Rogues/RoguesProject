extends Action
class_name DestroyFrontObjectAction

func execute(_context:BattleContext = null, _user:AbstractEntity = null):
	if _context.get_player().battle_position.get_object() != null:
		_context.get_player().battle_position.get_object().health.kill()
