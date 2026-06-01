extends Action
class_name FleeAction


func execute(_context:BattleContext = null, _user:AbstractEntity = null):
	if _user is MonsterEntity:
		_user.leave_battle("FLEE")
