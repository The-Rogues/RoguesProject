extends SpawnEnemyAction
class_name HatchLarvaeAction

func execute(_context:BattleContext = null, _user:AbstractEntity = null):
	if !_user:
		return
	var can_continue: bool = true
	await _user.get_tree().create_timer(0.2).timeout
	while can_continue:
		for i in range(0, _context.creature_manager.enemies.size()):
			if is_instance_valid(_context.creature_manager.enemies[i]) && _context.creature_manager.enemies[i].data.name == "Fire Ant Egg":
				var curr_enemy: MonsterEntity = _context.creature_manager.enemies[i]
				_context.creature_manager.enemies.erase(curr_enemy)
				curr_enemy.health.kill()
				
				await super(_context, _user)
				await _user.get_tree().create_timer(0.2).timeout
				break
			if i == _context.creature_manager.enemies.size() - 1:
				can_continue = false
	await _user.get_tree().create_timer(0.2).timeout
