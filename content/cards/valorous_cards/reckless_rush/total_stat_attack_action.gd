extends AttackAction
class_name TotalStatAttackAction

func execute(_context:BattleContext = null, _user:AbstractEntity = null):
	if !(_user is PlayerEntity):
		return
	amount = 0
	amount += _user.offensive_trait.weight_value
	amount += _user.defensive_trait.weight_value
	amount += _user.strategic_trait.weight_value
	super(_context, _user)
