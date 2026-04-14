extends DamageAction
class_name ProjectileAttackAction

@export var projectile_config:ProjectileFireData


func execute(_context:BattleContext = null, _user:AbstractEntity = null):
	for target in resolved_targets:
		_user.projectile_launcher.fire_sequence(target, projectile_config)
	await _user.projectile_launcher.projectiles_freed
