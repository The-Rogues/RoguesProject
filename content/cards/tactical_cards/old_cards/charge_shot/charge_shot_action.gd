extends ProjectileAttackAction
class_name ChargeShotAction


func execute(_context:BattleContext = null, _user:AbstractEntity = null):
	var final_damage:int = _calculate_damage(_context.get_player().cards)
	var config = projectile_config.duplicate(true)
	config.damage = final_damage
	
	for target in resolved_targets:
		if !target:
			continue
		
		if _user is PlayerEntity:
			var direction = (
					_user.global_position - target.global_position).normalized()
			_user.ranged_weapon.rotation = direction.angle()
		
		_user.projectile_launcher.fire_sequence(target.global_position, config)
		
	await _user.projectile_launcher.projectiles_freed


func _calculate_damage(player_cards:CardHandler) -> int:
	var final_damage = projectile_config.damage
	final_damage += player_cards.get_cards_by_name("Shot").size() * 4
	return final_damage
