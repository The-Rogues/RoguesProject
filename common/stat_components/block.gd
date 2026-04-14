extends Node
class_name Block

signal changed(current:int)

@export var value:int = 0


func add_block(amount:int) -> void:
	value += amount
	changed.emit(value)


func absorb_damage(damage:int) -> int:
	var remainder:int = damage - value
	value -= damage
	
	if value < 0:
		value = 0
	
	changed.emit(abs(value))
	
	return abs(remainder)


func set_to_zero():
	value = 0
	changed.emit(value)
