extends Action
class_name ApplyPositionEffectAction

@export var position_effect:PositionEffectConfig

func execute(_context:BattleContext = null, _user:AbstractEntity = null):
	var position = _context.battle_field.battle_positions.pick_random()
	position.add_position_effect(position_effect)
	await _context.battle_field.get_tree().create_timer(0.15).timeout
