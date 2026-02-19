class_name HealthComponent
extends RefCounted

signal health_changed(current, max)
signal reached_zero

var max_health: int
var current_health: int


func _init(max_health: int):
	self.max_health = max_health
	self.current_health = max_health


func take_damage(amount: int):
	current_health = max(current_health - amount, 0)
	health_changed.emit(current_health, max_health)
	
	if current_health == 0:
		reached_zero.emit()


func heal(amount: int):
	current_health = min(current_health + amount, max_health)
	health_changed.emit(current_health, max_health)


func set_to_zero():
	current_health = 0
	health_changed.emit(0, max_health)
	reached_zero.emit()
