extends Node
class_name Block

signal changed(current:int)

@export var value:int = 0


func add_block(amount:int) -> void:
	value += amount
	changed.emit(value)


func absorb_damage(damage:int) -> int:
	# Remaining damage after applying block
	var remainder:int = max(0, damage - value)
	# Update block value
	value = max(0, value - damage)
	
	
	changed.emit(value)
	
	return remainder


func set_to_zero():
	value = 0
	changed.emit(value)
