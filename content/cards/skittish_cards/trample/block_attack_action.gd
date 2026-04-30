extends AttackAction
class_name BlockAttackAction


func execute(_context:BattleContext = null, _user:AbstractEntity = null):
	if _user is AbstractCreature:
		amount = _user.block.value
		_user.block.set_to_zero()
	
	super(_context, _user)
