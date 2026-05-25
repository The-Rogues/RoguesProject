extends TargetedAction
class_name HuntPlayerAction

func execute(_context:BattleContext = null, _user:AbstractEntity = null):
	if resolved_targets.size() != 1:
		return
	if !is_instance_valid(_context.get_player()):
		return
	if _context.get_player().battle_position.get_object() != null:
		return
	for i in range(0, _context.battle_field.battle_positions.size()):
		if _context.battle_field.battle_positions[i].get_object() == resolved_targets[0]:
			var curr_object = _context.battle_field.battle_positions[i].get_object()
			_context.battle_field.place_object(
				load("res://content/monsters/savage/moves/nowhere_to_hide/savage_object.tres"),
				_context.get_player().battle_position
			)
			_context.get_player().battle_position.get_object().health.set_values(
				curr_object.health.value,
				curr_object.health.max_value
			)
			curr_object.health.kill()
			return
