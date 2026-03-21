extends StatusEffectData
class_name StickyBombStatus

@export var blow_up_particles:PackedScene


func on_remove(entity: BattleEntity, instance: StatusEffect) -> void:
	var particles:CPUParticles2D = blow_up_particles.instantiate()
	entity.get_parent().add_child(particles)
	particles.global_position = entity.global_position
	particles.emitting = true
	await particles.finished
	particles.queue_free()
	
	entity.take_damage(instance.stack_count)


func get_description(instance: StatusEffect) -> String:
	return "Detonates in " + str(instance.duration) + "turns, dealing " + str(instance.stack_count) + " damage."
