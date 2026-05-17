extends Action
class_name ApplyPositionEffectAction

@export var position_effect:PositionEffectConfig
@export var count: int = 1

func execute(_context:BattleContext = null, _user:AbstractEntity = null):
	var pos_options: Array[BattlePosition]
	for i in range(0, _context.battle_field.battle_positions.size()):
		if !_context.battle_field.battle_positions[i]._effect:
			pos_options.append(_context.battle_field.battle_positions[i])
		elif _context.battle_field.battle_positions[i]._effect.data != position_effect:
			pos_options.append(_context.battle_field.battle_positions[i])
	for i in range(0, count):
		var position: BattlePosition
		if pos_options.size() == 0:
			position = _context.battle_field.battle_positions.pick_random()
		else:
			position = pos_options.pick_random()
		position.remove_position_effect()
		position.add_position_effect(position_effect)
		pos_options.erase(position)
	await _context.battle_field.get_tree().create_timer(0.15).timeout
