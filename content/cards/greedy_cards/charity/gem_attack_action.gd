extends DamageAction
class_name GemAttackAction

@export var projectile_config:ProjectileFireData
var gem_behavior: Resource = preload("res://content/cards/greedy_cards/gem_behavior/gem_behavior.tres")

func execute(_context:BattleContext = null, _user:AbstractEntity = null):
	
	if _user is not PlayerEntity:
		return
		
	var player = _context.get_player()
	var num_gems = get_num_gems(player)
	
	for i in range(0, num_gems):
		
		if _context.creature_manager.enemies.size() == 0:
			return
			
		var target: MonsterEntity = _context.creature_manager.enemies.pick_random()
		
		var direction = (
				_user.global_position - target.global_position).normalized()
		_user.ranged_weapon.rotation = direction.angle()
		
		_user.projectile_launcher.fire_sequence(target.global_position, projectile_config)
		
		await player.get_tree().create_timer(0.2).timeout
	await _user.projectile_launcher.projectiles_freed

func get_num_gems(player: PlayerEntity) -> int:
	for i in range(0, player.effects.active_effects.size()):
		if player.effects.active_effects[i].effect == gem_behavior:
			return player.effects.active_effects[i].stack
	return 0
