extends DamageAction
class_name ProjectileAttackAction

@export var projectile_config:ProjectileFireData


func execute(_context:BattleContext = null, _user:AbstractEntity = null):
	for target in resolved_targets:
		if !target:
			continue
		
		if _user is PlayerEntity:
			var direction = (
					_user.global_position - target.global_position).normalized()
			_user.ranged_weapon.rotation = direction.angle()
		
		_user.projectile_launcher.fire_projectile(target.global_position, projectile_config)
		
	await _user.projectile_launcher.projectiles_freed
