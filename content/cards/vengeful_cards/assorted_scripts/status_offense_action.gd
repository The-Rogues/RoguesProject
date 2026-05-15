extends ApplyStatusAction
class_name StatusOffenseAction

func execute(_context:BattleContext = null, _user:AbstractEntity = null):
	if _user is not PlayerEntity:
		return
	effect.stack = _user.offensive_trait.weight_value
	await super(_context, _user)
