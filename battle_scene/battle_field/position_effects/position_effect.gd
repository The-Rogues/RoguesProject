extends Node2D
class_name PositionEffect

signal effect_ended

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var cpu_particles_2d: CPUParticles2D = $CPUParticles2D
@export var data:PositionEffectConfig

var duration:int = -1
var stack:int = -1


func initialize(effect_data:PositionEffectConfig):
	data = effect_data
	duration = effect_data.duration
	stack = effect_data.stack
	
	if effect_data.display.floor_texture:
		sprite_2d.texture = effect_data.display.floor_texture
		sprite_2d.self_modulate = effect_data.display.floor_color
	
	if effect_data.display.particle_texture:
		cpu_particles_2d.texture = effect_data.display.particle_texture
		cpu_particles_2d.color = effect_data.display.particle_color
		cpu_particles_2d.emitting = true
	else:
		cpu_particles_2d.emitting = false


func on_player_entered(player:PlayerEntity):
	if data:
		data.behaviour.on_entered(player, self)


func on_player_exited(player:PlayerEntity):
	if data:
		data.behaviour.on_exited(player, self)


func end_effect():
	effect_ended.emit()
