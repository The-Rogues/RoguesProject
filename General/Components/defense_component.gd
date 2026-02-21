extends RefCounted
class_name DefenseComponent

signal defense_changed(current)
signal reached_zero

var current_defense: int = 0


func add_defense(amount:int):
	current_defense += amount
	defense_changed.emit(current_defense)


func block_damage(damage_amount:int):
	var current = current_defense
	current_defense = max(0, current_defense - damage_amount)
	defense_changed.emit(current_defense)
	return max(0, damage_amount - current)


func set_to_zero():
	current_defense = 0
	defense_changed.emit(0)
	reached_zero.emit()
