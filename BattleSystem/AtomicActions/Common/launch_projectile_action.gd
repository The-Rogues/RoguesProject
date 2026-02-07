extends AtomicAction
class_name LaunchProjectileAction

const ATTACK_PROJECTILE = preload("res://BattleSystem/Entities/Enemies/Attacks/Projectiles/attack_projectile.tscn")

enum TargetMode {TARGETED, ANGLE}
@export var projectile_texture:Texture2D
@export var target_mode:TargetMode
@export var impact_damage:int
@export var speed : float = 400
@export var face_projectile:bool = false
@export_range(0, 1) var direction_range:float = 0.35

func execute(action_context: ActionContext) -> void:
	var user = action_context.user
	
	for target in action_context.targets:
		var direction: Vector2
		match target_mode:
			TargetMode.TARGETED:
				direction = user.global_position.direction_to(target.global_position)
			TargetMode.ANGLE:
				var base_direction = user.global_position.direction_to(target.global_position)
				# Determine vertical relationship
				var target_is_below = target.global_position.y > user.global_position.y
				# Angle range depends on vertical direction
				var min_angle: float
				var max_angle: float
				if target_is_below:
					# Only allow downward deviation
					min_angle = 0.0
					max_angle = direction_range * PI
				else:
					# Only allow upward deviation
					min_angle = -direction_range * PI
					max_angle = 0.0
				var angle_offset := randf_range(min_angle, max_angle)
				direction = base_direction.rotated(angle_offset)
		var projectile: AttackProjectile = ATTACK_PROJECTILE.instantiate()
		user.add_child(projectile)
		
		if target.entity_data is CharacterData:
			projectile.damages = AttackProjectile.DamageTarget.PLAYER
		elif target.entity_data is EnemyData:
			projectile.damages = AttackProjectile.DamageTarget.ENEMY
		else:
			projectile.damages = AttackProjectile.DamageTarget.PLAYER
		
		projectile.speed = speed
		projectile.sprite_2d.texture = projectile_texture
		projectile.damage = impact_damage
		if face_projectile:
			projectile.sprite_2d.rotation = direction.angle()-80
		projectile.spawn_and_launch(user.global_position, direction)
