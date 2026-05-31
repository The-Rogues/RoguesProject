extends Action
class_name FillOpportunityAction

@export var new_spaces: Array[PositionEffectConfig]

func execute(_context:BattleContext = null, _user:AbstractEntity = null):
	for i in range(0, _context.battle_field.battle_positions.size()):
		_context.battle_field.battle_positions[i].remove_position_effect()
		_context.battle_field.battle_positions[i].add_position_effect(new_spaces.pick_random())
