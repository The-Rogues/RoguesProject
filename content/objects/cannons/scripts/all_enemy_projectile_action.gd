extends DamageAction
class_name AllEnemyProjectileAction

@export var projectile_config:ProjectileFireData

func execute(_context:BattleContext = null, _user:AbstractEntity = null):
	_user = _context.get_player().battle_position.get_object()
	var processed_enemies: Array[MonsterEntity] = []
	var i: int = 0
	while i < _context.creature_manager.enemies.size():
		
		for target in _context.creature_manager.enemies:
			if processed_enemies.has(target):
				i += 1
				continue
			if !target:
				i += 1
				continue
		
			if is_instance_valid(target) && target.health.is_alive:
				_user.projectile_launcher.fire_projectile(target.global_position, projectile_config)
				await _user.projectile_launcher.projectiles_freed
			
			i = 0
			processed_enemies.append(target)
			break
