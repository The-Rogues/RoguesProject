extends TargetedAction
class_name KillAction


func execute(_context:BattleContext = null, _user:AbstractEntity = null):
	_user.health.kill()
	await _context.creature_manager.get_tree().create_timer(0.15).timeout
