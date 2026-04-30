extends Action
class_name FillOpportunityAction

@export var new_space: PositionEffectConfig

func execute(_context:BattleContext = null, _user:AbstractEntity = null):
	for i in range(0, _context.battle_field.battle_positions.size()):
		_context.battle_field.battle_positions[i].add_position_effect(new_space)
