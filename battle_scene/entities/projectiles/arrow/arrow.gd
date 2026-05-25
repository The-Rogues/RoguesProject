extends Projectile
class_name Arrow

@onready var stuck_arrow: Node2D = %StuckArrow


func _on_hitbox_area_entered(area: Area2D) -> void:
	var entity := area.get_parent() as AbstractEntity

	# Ignore source
	if entity == source:
		return

	# Hit non-entity objects (walls, props, etc)
	if entity == null:
		destroy(area)
		return

	# Ignore invalid targets
	if !_can_damage_entity(entity):
		return

	_attach_arrow(entity)

	entity.take_damage(damage, self)

	if entity is AbstractCreature and status:
		entity.apply_status_effect(status)

	destroy(entity)


func _attach_arrow(entity: AbstractEntity) -> void:
	var arrow_transform := stuck_arrow.global_transform

	stuck_arrow.reparent(entity, true)

	stuck_arrow.global_transform = arrow_transform
	stuck_arrow.global_rotation = velocity.angle()

	stuck_arrow.visible = true
