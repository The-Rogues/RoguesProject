extends RefCounted
class_name BattlePowersManager


var active_powers:Array[BattlePower] = []


func _init() -> void:
	active_powers = []


func add_power(power:BattlePower, context:BattleContext) -> bool:
	if !power.can_reapply:
		for active_power in active_powers:
			if active_power.get_script() == power.get_script():
				active_power.on_stack()
				return false
	
	var instance = power.duplicate(true)
	active_powers.append(instance)
	
	instance.on_apply(context)
	instance.power_ended.connect(remove_power)
	return true


func enter_turn(context:BattleContext):
	for active_power in active_powers:
		active_power.on_turn_entered(context)

func end_turn(context:BattleContext):
	for active_power in active_powers:
		active_power.on_turn_ended(context)

func remove_power(power:BattlePower) -> bool:
	for active_power in active_powers:
		if active_power.get_script() == power.get_script():
			active_powers.erase(active_power)
			active_power.on_remove()
			return true
	return false
