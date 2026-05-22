extends Action
class_name KillObjectByNameAction

@export var obj_name: String

func execute(_context:BattleContext = null, _user:AbstractEntity = null):
	for i in range(0, _context.battle_field.battle_positions.size()):
		if _context.battle_field.battle_positions[i].get_object() != null:
			if _context.battle_field.battle_positions[i].get_object().data.name == obj_name:
				_context.battle_field.battle_positions[i].get_object().health.kill()
