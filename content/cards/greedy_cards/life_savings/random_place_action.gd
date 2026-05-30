extends Action
class_name RandomPlaceAction

@export var object_pool: Array[ObjectData]

func execute(_context:BattleContext = null, _user:AbstractEntity = null):
	var empty_positions: Array[BattlePosition] = []
	for i in range(0, _context.battle_field.battle_positions.size()):
		if _context.battle_field.battle_positions[i].get_object() == null:
			empty_positions.append(_context.battle_field.battle_positions[i])
	
	if empty_positions.size() == 0:
		return
	
	_context.battle_field.place_object(object_pool.pick_random(), empty_positions.pick_random())
	
	if _context.get_player().battle_position.get_object() && _context.get_player().battle_position.get_object().data.targeting_categories.has(ObjectData.MoveTargetingCategory.WEAPON):
		_context.get_player().battle_position.get_object().object_stat_display.interaction_button.visible = true
	
	await _context.battle_field.get_tree().create_timer(0.15).timeout
