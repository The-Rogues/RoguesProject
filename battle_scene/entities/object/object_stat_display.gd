extends Control
class_name ObjectStatDisplay

@onready var health_bar: HealthBar = $HealthBar


func initialize(object:ObjectEntity):
	health_bar.initialize(object.health)
	object.health.health_changed.connect(_on_health_changed)
	health_bar.visible = false


func _on_health_changed(current:int, max:int):
	health_bar.visible = current > 0
