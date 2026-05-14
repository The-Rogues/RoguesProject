extends Action
class_name AddEnergyAction

@export var amount: int = 1

func execute(_context:BattleContext = null, _user:AbstractEntity = null):
	if _user is not PlayerEntity:
		return
	_user.energy.set_energy(_user.energy.value + amount, _user.energy.max_value)
