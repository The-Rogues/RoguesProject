extends AtomicAction
class_name ProjectileAttackAction
## AtomicAction that spawns and launches attack projectiles toward targets.
##
## Instantiates a projectile at the user’s position and launches it either 
## directly at the target or along a randomized angular deviation based on 
## vertical positioning, for each targeted entity.
##
## Projectiles are configured with damage, speed, visual appearance, and
## valid damage targets before being launched.
##
## Projectile handle their own logic for damaging entities


const ATTACK_PROJECTILE = preload("res://BattleSystem/Entities/Enemies/Attacks/Projectiles/attack_projectile.tscn")

## Replaces the default projectile texture
@export var projectile_texture:Texture2D
## Toggles whether the projectile sprite will rotate to face it's movement
## direction. Useful for directional projectile textures.
@export var face_direction:bool = false
## Controls the damage that the launched projectile will deal towards a
## targeted entity
@export var impact_damage:int
## Controls the speed that the projectile moves 
@export var speed : float = 400
## Controls the deviation in angular degrees that the projectile will launch
## towards. Set to 0 if you want the projectile to move straight towards the
## targeted entity's position
@export_range(0, 1) var direction_range:float = 0.35


func execute(action_context: ActionContext) -> void:
	var user = action_context.user
	
	for target in action_context.targets:
		var direction: Vector2 = user.global_position.direction_to(
					target.global_position
					)
		var target_is_below = target.global_position.y > user.global_position.y
		
		var min_angle:float
		var max_angle:float
		if target_is_below:
			# Only allow downward deviation
			min_angle = 0.0
			max_angle = direction_range * PI
		else:
			# Only allow upward deviation
			min_angle = -direction_range * PI
			max_angle = 0.0
		
		var angle_offset:float = randf_range(min_angle, max_angle)
		direction = direction.rotated(angle_offset)
		
		var projectile: AttackProjectile = ATTACK_PROJECTILE.instantiate()
		user.add_child(projectile)
		var damage_target:AttackProjectile.DamageTarget
		
		if target.entity_data is CharacterData:
			damage_target = AttackProjectile.DamageTarget.PLAYER
		elif target.entity_data is EnemyData:
			damage_target = AttackProjectile.DamageTarget.ENEMY
		else:
			# Panic case
			damage_target = AttackProjectile.DamageTarget.PLAYER
		
		var final_damage:int = impact_damage
		if user is BattleEntity:
			final_damage = user.get_attack_damage(final_damage)
		
		projectile.configure(
			damage_target,
			projectile_texture,
			speed,
			impact_damage,
			face_direction
		)
		
		projectile.spawn_and_launch(user.global_position, direction)
		await user.get_tree().create_timer(0.15).timeout
