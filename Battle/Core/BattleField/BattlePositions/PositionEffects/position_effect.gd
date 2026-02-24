extends Node2D
class_name PositionEffect

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var cpu_particles_2d: CPUParticles2D = $CPUParticles2D
@export var data:PositionEffectData

func initialize(effect_data:PositionEffectData):
	data = effect_data
	if effect_data.position_texture:
		sprite_2d.texture = effect_data.position_texture
	sprite_2d.self_modulate = effect_data.position_texture_color
	visible = true
	
	if effect_data.use_particles:
		cpu_particles_2d.texture = effect_data.particle_texture
		cpu_particles_2d.emitting = true
		cpu_particles_2d.color = effect_data.particle_texture_color
	else:
		cpu_particles_2d.emitting = false

func on_entered(entity:BattleEntity):
	if not data:
		return
	
	data.on_entered(entity)
	pass

func on_exited(entity:BattleEntity):
	if not data:
		return
	
	data.on_exited(entity)
	pass

func on_turn_started(entity:BattleEntity):
	if not data:
		return
		
	data.on_turn_started(entity)
	pass

func end_effect():
	data = null
	cpu_particles_2d.emitting = false
	visible = false
