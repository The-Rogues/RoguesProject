extends Node2D
class_name ProjectileLauncher

@export var projectile_scene:PackedScene
@export var fire_delay:Timer
@export var fire_point:Node2D


func fire(target_position:Vector2, data:ProjectileFireData):
	if projectile_scene == null:
		return
	
	var projectile:Projectile = projectile_scene.instantiate()
	
	projectile.global_position = fire_point.global_position
	
	projectile.target_position = target_position
	projectile.source = data.source
	projectile.damage = data.damage
	projectile.ignore_block = data.bypass_block
	projectile.ignore_walls = data.bypass_wall
	if data.status_effect:
		projectile.status_effect = data.status_effect.duplicate()
	
	get_tree().current_scene.add_child(projectile)


func fire_sequence(target, data:ProjectileFireData):
	if projectile_scene == null:
		return
	
	for i in data.projectile_count:
		fire(target, data)
		
		if data.delay > 0:
			fire_delay.start(data.delay)
			await fire_delay.timeout
