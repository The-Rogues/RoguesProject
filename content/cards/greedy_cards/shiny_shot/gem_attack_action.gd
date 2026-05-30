extends DamageAction
class_name GemAttackAction

@export var projectile_config:ProjectileFireData
var gem_behavior: Resource = preload("res://content/cards/greedy_cards/gem_behavior/gem_behavior.tres")

func execute(_context:BattleContext = null, _user:AbstractEntity = null):
	if _user is not PlayerEntity:
		return
	
	var player = _context.get_player()
	var num_gems = get_num_gems(player)
	var target_options = _context.creature_manager.enemies.duplicate(true)
	
	for i in range(0, num_gems):
		if target_options.size() == 0:
			break
		
		var target
		if player.battle_position.get_object() != null && player.battle_position.get_object().health.value != 0:
			target = player.battle_position.get_object()
		else:
			target = target_options.pick_random()
		
		if is_instance_valid(target):
			var direction = (
					_user.global_position - target.global_position).normalized()
			_user.ranged_weapon.rotation = direction.angle()
		
			_user.projectile_launcher.fire_projectile(target.global_position, projectile_config)
		
			if i != (num_gems - 1):
				await player.get_tree().create_timer(0.2).timeout
		else:
			target_options.erase(target)
			num_gems += 1
	
	if num_gems > 0:
		await _user.projectile_launcher.projectiles_freed

func get_num_gems(player: PlayerEntity) -> int:
	for i in range(0, player.effects.active_effects.size()):
		if player.effects.active_effects[i].effect == gem_behavior:
			return player.effects.active_effects[i].stack
	return 0
