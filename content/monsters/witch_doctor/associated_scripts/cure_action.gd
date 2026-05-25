extends Action
class_name CureAction

func execute(_context:BattleContext = null, _user:AbstractEntity = null):
	for i in range(0, _context.get_player().effects.active_effects.size()):
		if _context.get_player().effects.active_effects[i].effect is InfectedBehavior:
			_context.get_player().stat_display.status_effect_container.icons[
				_context.get_player().effects.active_effects[i]
			].queue_free()
			_context.get_player().stat_display.status_effect_container.icons.erase(
				_context.get_player().effects.active_effects[i]
			)
			_context.get_player().effects.active_effects.erase(
				_context.get_player().effects.active_effects[i]
			)
			return
