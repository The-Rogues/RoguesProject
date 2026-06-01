extends Node2D
class_name ProjectileLauncher
## Projectile launcher handler
##
## Configurable projectile launcher that reads firing _config to determine what
## how many, how fast, how much damage, and if the projectile will apply any
## status effects. Also keeps track of fired projectiles and signals when they've
## been freed
## Author: Fabian

signal fired_projectile(projectile:Projectile)
signal projectiles_freed

@export var fire_delay:Timer
@export var fire_point:Node2D
@export var group:String = ""
@export var configuration:ProjectileFireData = null

var projectiles:Array[Projectile]

## Instantiates and configers a Projectile. Requires that launcher is already
## configured or that _config is passed. Nothing happens otherwise
func fire_projectile(
	target_position:Vector2, 
	_config:ProjectileFireData = null):
	if _config:
		configuration = _config
	
	if !configuration:
		printerr("Projectile Launcher Configuration left unset")
		return
	
	for i in range(_config.projectile_count):
		var projectile := _create_projectile()
		projectile.initialize(fire_point.global_position, target_position)
		
		fired_projectile.emit(projectile)
		
		if _config.fire_delay > 0:
			fire_delay.start(_config.fire_delay)
			await fire_delay.timeout

## Instantiates and modifies a Projectile. If launcher is not configured, 
## then nothing happens.
func _create_projectile() -> Projectile:
	if configuration:
		var projectile:Projectile = configuration.projectile_scene.instantiate()
		get_tree().current_scene.add_child(projectile)
		
		projectile.source = get_parent()
		
		if configuration.impact_damage != -1:
			projectile.impact_damage = configuration.impact_damage
		
		if configuration.impact_status_effect:
			projectile.impact_status_effect = configuration.impact_status_effect
		
		if group != "":
			projectile.add_to_group(group)
		
		projectiles.append(projectile)
		projectile.freed.connect(_projectile_freed)
		
		return projectile
	
	return null

## Signals when all projectiles have been freed.
func _projectile_freed(projectile:Projectile):
	projectiles.erase(projectile)
	
	if projectiles.is_empty():
		projectiles_freed.emit()
