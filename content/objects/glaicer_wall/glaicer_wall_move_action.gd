extends TargetedAction
class_name GlaicerWallMoveAction

@export var is_right: bool = true

func execute(_context:BattleContext = null, _user:AbstractEntity = null):
	if resolved_targets.size() != 1:
		return
	for i in range(0, _context.battle_field.battle_positions.size()):
		if _context.battle_field.battle_positions[i].get_object() == resolved_targets[0]:
			var curr_object = _context.battle_field.battle_positions[i].get_object()
			if is_right:
				if (i != 4) && (_context.battle_field.battle_positions[i + 1].get_object() == null):
					_context.battle_field.place_object(
						load("res://content/objects/glaicer_wall/glacier_wall_right.tres"),
						_context.battle_field.battle_positions[i + 1]
					)
					_context.battle_field.battle_positions[i + 1].get_object().health.set_values(
						curr_object.health.value,
						curr_object.health.max_value
					)
					curr_object.health.kill()
					return
					
				if i == 0:
					return
				elif _context.battle_field.battle_positions[i - 1].get_object() != null:
					return
				else:
					_context.battle_field.place_object(
						load("res://content/objects/glaicer_wall/glacier_wall_left.tres"),
						_context.battle_field.battle_positions[i - 1]
					)
					_context.battle_field.battle_positions[i - 1].get_object().health.set_values(
						curr_object.health.value,
						curr_object.health.max_value
					)
					curr_object.health.kill()
					return
			else:
				if (i != 0) && (_context.battle_field.battle_positions[i - 1].get_object() == null):
					_context.battle_field.place_object(
						load("res://content/objects/glaicer_wall/glacier_wall_left.tres"),
						_context.battle_field.battle_positions[i - 1]
					)
					_context.battle_field.battle_positions[i - 1].get_object().health.set_values(
						curr_object.health.value,
						curr_object.health.max_value
					)
					curr_object.health.kill()
					return
				if i == 4:
					return
				elif _context.battle_field.battle_positions[i + 1].get_object() != null:
					return
				else:
					_context.battle_field.place_object(
						load("res://content/objects/glaicer_wall/glacier_wall_right.tres"),
						_context.battle_field.battle_positions[i + 1]
					)
					_context.battle_field.battle_positions[i + 1].get_object().health.set_values(
						curr_object.health.value,
						curr_object.health.max_value
					)
					curr_object.health.kill()
					return
