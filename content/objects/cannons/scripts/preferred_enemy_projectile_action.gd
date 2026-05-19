extends DamageAction
class_name PreferedEnemyProjectileAction

@export var projectile_config:ProjectileFireData

func execute(_context:BattleContext = null, _user:AbstractEntity = null):
	_user = _context.get_player().battle_position.get_object()
	
	if !_user:
		return
	
	target_option = TargetOption.ENEMY
	ignore_foreground = true
	var target = _context.resolve_targeting.call(
		self,
		_context.get_player()
	).pick_random()
		
	if is_instance_valid(target):
		_user.projectile_launcher.fire_sequence(target.global_position, projectile_config)
	
	await _user.projectile_launcher.projectiles_freed
