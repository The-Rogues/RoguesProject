extends Action
class_name AddPowerAction

@export var power:BattlePower


func execute(_context:BattleContext = null, _user:AbstractEntity = null):
	_context.add_power.call(power, _context)
	await _context.creature_manager.get_tree().create_timer(0.15).timeout
