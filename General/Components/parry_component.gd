extends RefCounted
class_name ParryComponent

signal parry_changed(current)
signal reached_zero

var current_parry: int = 1


func add_parry(amount:int):
	current_parry += amount
	parry_changed.emit(current_parry)


func use_parry():
	var current = current_parry
	current_parry = 0
	parry_changed.emit(current_parry)
	return current


func set_to_zero():
	current_parry = 0
	parry_changed.emit(0)
	reached_zero.emit()
