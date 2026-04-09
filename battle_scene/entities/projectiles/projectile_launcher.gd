extends Node2D
class_name ProjectileLauncher

signal projectiles_freed

var projectile_scene:PackedScene
@export var fire_delay:Timer
@export var fire_point:Node2D

var projectiles:Array[Projectile]

func fire(target_position:Vector2, data:ProjectileFireData):
	if projectile_scene == null:
		return
	
	projectile_scene = data.projectile_scene
	var projectile:Projectile = projectile_scene.instantiate()
	projectile.target_position = target_position
	projectile.global_position = fire_point.global_position
	get_tree().current_scene.add_child(projectile)
	projectiles.append(projectile)
	projectile.freed.connect(projectile_freed)


func fire_sequence(target:Node2D, data:ProjectileFireData):
	projectile_scene = data.projectile_scene
	
	for i in data.projectile_count:
		fire(target.global_position, data)
		
		if data.fire_delay > 0:
			fire_delay.start(data.fire_delay)
			await fire_delay.timeout


func projectile_freed(projectile:Projectile):
	print("removed projectile, projectiles left: ", projectiles.size())
	projectiles.erase(projectile)
	
	if projectiles.is_empty():
		print("freed")
		projectiles_freed.emit()
	pass
