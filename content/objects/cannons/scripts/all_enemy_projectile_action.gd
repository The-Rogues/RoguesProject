extends DamageAction
class_name AllEnemyProjectileAction

@export var projectile_config:ProjectileFireData

func execute(_context:BattleContext = null, _user:AbstractEntity = null):
	_user = _context.get_player().battle_position.get_object()
	for target in _context.creature_manager.enemies:
		if !target:
			continue
		
		if is_instance_valid(target):
			_user.projectile_launcher.fire_sequence(target.global_position, projectile_config)
		
	await _user.projectile_launcher.projectiles_freed
