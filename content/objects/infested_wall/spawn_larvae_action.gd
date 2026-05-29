extends SpawnEnemyAction
class_name SpawnLarvaeAction

func execute(_context:BattleContext = null, _user:AbstractEntity = null):
	if _context.creature_manager.enemies.size() < 6:
		if _context.is_player_turn:
			choose_intent = true
		else:
			choose_intent = false
			await super(_context, _user)
