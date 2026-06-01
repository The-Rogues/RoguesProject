extends ProjectileAttackAction
class_name ChargeShotActionNew

func execute(_context:BattleContext = null, _user:AbstractEntity = null):
	if _user is not PlayerEntity:
		return
	var projectile_count: int = _calculate_count(_context.get_player().cards)
	
	for i in range(0, projectile_count):
		if resolved_targets.size() == 0:
			break
		var target = resolved_targets.pick_random()
		if is_instance_valid(target) && target.health.is_alive:
			var direction = (
					_user.global_position - target.global_position).normalized()
			_user.ranged_weapon.rotation = direction.angle()
			_user.projectile_launcher.fire_projectile(target.global_position, projectile_config)
			await _user.projectile_launcher.projectiles_freed
		else:
			resolved_targets.erase(target)
			projectile_count += 1


func _calculate_count(player_cards:CardHandler) -> int:
	var ret_val: int = player_cards.get_cards_by_name("Agile Shot").size()
	ret_val += player_cards.get_cards_by_name("Arrow Shot").size()
	ret_val += player_cards.get_cards_by_name("Charge Shot").size()
	ret_val += player_cards.get_cards_by_name("Heartbreak Shot").size()
	ret_val += player_cards.get_cards_by_name("Shiny Shot").size()
	ret_val += player_cards.get_cards_by_name("Frozen Shot").size()
	ret_val += player_cards.get_cards_by_name("Thoughtful Shot").size()
	return ret_val + 1
