# Author: Fabian

# Spawns and plays a pop particle effect when entity is defeated

extends EntityBehaviour
class_name OnDeathPop

# Loads Particle effect used for death pop
const POP_PARTICLES = preload("res://Nodes/Effects/star_pop.tscn")
var entity_sprite:Sprite2D

func initialize(new_battle_entity:Node2D):
	super(new_battle_entity)
	entity_sprite = new_battle_entity.entity_sprite
	entity_instance.defeated.connect(_on_entity_defeated)

func _on_entity_defeated(entity:BattleEntity):
	# Wait for enemy death animation to finish
	await  entity.entity_animator.animation_finished
	
	entity_sprite.visible = false
	# Create and play particle
	var particles:CPUParticles2D = POP_PARTICLES.instantiate()
	entity.add_child(particles)
	particles.global_position = entity.global_position
	particles.emitting = true
	# Wait until particle finishes emission to free memory
	await particles.finished
	particles.queue_free()
