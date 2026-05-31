extends Action
class_name DestroyAllObjectsAction

func execute(_context:BattleContext = null, _user:AbstractEntity = null):
	for i in range(0, _context.battle_field.battle_positions.size()):
		if _context.battle_field.battle_positions[i].get_object():
			_context.battle_field.battle_positions[i].get_object().health.kill()
	await _user.get_tree().create_timer(0.15).timeout
