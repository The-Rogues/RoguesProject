extends DamageAction
class_name RandomFireProjectileAction

@export var projectile_configs: Array[ProjectileFireData]
@export var hits: int

func execute(_context:BattleContext = null, _user:AbstractEntity = null):
	for target in resolved_targets:
		if !target:
			continue
		
		if _user is PlayerEntity:
			var direction = (
					_user.global_position - target.global_position).normalized()
			_user.ranged_weapon.rotation = direction.angle()
		
		for i in range(0, hits):
			if is_instance_valid(target) && target.health.is_alive:
				_user.projectile_launcher.fire_projectile(target.global_position, projectile_configs.pick_random())
				await _user.projectile_launcher.projectiles_freed
