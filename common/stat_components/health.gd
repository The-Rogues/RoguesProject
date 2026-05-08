extends Node
class_name Health

signal health_changed(current, max)
signal damaged(amount)
signal healed(amount)
signal died
signal revived

@export var value:int = 100
@export var max_value:int = 100

var is_alive:bool = true
var can_heal:bool = true
var invincible:bool = false


func initialize(current:int, max:int) -> void:
	max_value = max
	value = clampi(current, 0, max)
	health_changed.emit(value, max_value)


func take_damage(amount:int) -> void:
	if !is_alive:
		return
	
	if invincible:
		damaged.emit(0)
		return
	
	value = max(value - amount, 0)
	health_changed.emit(value, max_value)
	
	if value == 0:
		is_alive = false
		died.emit()
	else:
		damaged.emit(amount)


func heal(amount:int) -> void:
	if !is_alive or !can_heal:
		return
	
	value = min(value + amount, max_value)
	health_changed.emit(value, max_value)
	healed.emit(amount)


func kill() -> void:
	if !is_alive:
		return
	
	value = 0
	health_changed.emit(value, max_value)
	is_alive = false
	died.emit()


func revive() -> void:
	value = max_value
	is_alive = true
	
	health_changed.emit(value, max_value)
	revived.emit()


func set_values(_current:int, _max:int):
	value = _current
	max_value = _max
	health_changed.emit(value, max_value)
