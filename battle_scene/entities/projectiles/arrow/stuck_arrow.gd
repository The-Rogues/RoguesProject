extends Node2D
## Script for Stuck Arrow Object.
##
## Attatches dangling arrow to entity when an arrow hits a valid object.
## Author: Fabian.

@export var arrow:Projectile


func _ready() -> void:
	if arrow:
		arrow.hit.connect(_attach_arrow)


func _attach_arrow(entity: AbstractEntity) -> void:
	var arrow_transform := global_transform
	reparent(entity, true)

	global_transform = arrow_transform
	global_rotation = arrow.velocity.angle() # Face hit direction

	visible = true
