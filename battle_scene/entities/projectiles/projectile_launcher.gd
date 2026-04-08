extends Node2D
class_name ProjectileLauncher

var projectile_scene:PackedScene
@export var fire_delay:Timer
@export var fire_point:Node2D


func fire(target_position:Vector2, data:ProjectileFireData):
	if projectile_scene == null:
		return
	
	projectile_scene = data.projectile_scene
	var projectile:Projectile = projectile_scene.instantiate()
	projectile.target_position = target_position
	get_tree().current_scene.add_child(projectile)
	projectile.global_position = fire_point.global_position


func fire_sequence(target, data:ProjectileFireData):
	if projectile_scene == null:
		return
	
	for i in data.projectile_count:
		fire(target, data)
		
		if data.delay > 0:
			fire_delay.start(data.delay)
			await fire_delay.timeout
