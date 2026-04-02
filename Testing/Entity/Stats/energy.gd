extends Node
class_name Energy

signal energy_changed(current:int, max:int)
signal failed_to_spend
signal depleted


@export_range(0, 10) var value:int = 3
@export_range(1,10) var max_value:int = 3


func initialize(starting:int, maximum:int):
	value = starting
	max_value = maximum
	energy_changed.emit(starting, maximum)


func replenish(amount:int) -> void:
	value = min(max_value, value + amount)
	energy_changed.emit(value, max_value)


func spend(amount:int) -> bool:
	var remaining = value - amount
	if remaining >= 0:
		value = remaining
		energy_changed.emit(value, max_value)
		
		if value == 0:
			depleted.emit()
		
		return true
	
	failed_to_spend.emit()
	return false


func refill():
	value = max_value
	energy_changed.emit(value, max_value)
