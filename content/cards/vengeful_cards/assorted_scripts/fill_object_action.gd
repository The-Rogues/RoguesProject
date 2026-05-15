extends Action
class_name FillObjectAction

@export var fill_object: ObjectData

func execute(_context:BattleContext = null, _user:AbstractEntity = null):
	for i in range(0, _context.battle_field.battle_positions.size()):
		if _context.battle_field.battle_positions[i].get_object() == null:
			_context.battle_field.place_object(
				fill_object,
				_context.battle_field.battle_positions[i]
			)
	_context.get_player().battle_position.get_object().object_stat_display.interaction_button.visible = true
