extends Node
class_name Block

signal changed

@export var value:int = 0


func add_block(amount:int) -> void:
	value += amount
	changed.emit(value)


func absorb_damage(damage:int) -> int:
	var remainder:int = damage - value
	value = max(value - damage, 0)
	changed.emit(value)
	
	return remainder


func set_to_zero():
	value = 0
	changed.emit(value)
