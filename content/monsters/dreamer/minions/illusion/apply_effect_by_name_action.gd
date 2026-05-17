extends Action
class_name ApplyEffectByNameAction

@export var effect: StatusEffectConfig
@export var name: String 

func execute(_context:BattleContext = null, _user:AbstractEntity = null):
	for i in range(0, _context.creature_manager.enemies.size()):
		if _context.creature_manager.enemies[i].data.name == name:
			_context.creature_manager.enemies[i].apply_status_effect(effect)
			_context.creature_manager.enemies[i].intent_chosen.emit(
				_context.creature_manager.enemies[i].intent
			)
