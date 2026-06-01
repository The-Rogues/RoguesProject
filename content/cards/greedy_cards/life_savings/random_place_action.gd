extends Action
class_name RandomPlaceAction

@export var object_pool: Array[ObjectData]

func execute(_context:BattleContext = null, _user:AbstractEntity = null):
	
	var track_achievement: bool = false
	if _user is PlayerEntity:
		track_achievement = true
	
	var empty_positions: Array[BattlePosition] = []
	for i in range(0, _context.battle_field.battle_positions.size()):
		if (_context.battle_field.battle_positions[i].get_object() == null) || !_context.battle_field.battle_positions[i].get_object().health.is_alive:
			empty_positions.append(_context.battle_field.battle_positions[i])
	
	if empty_positions.size() == 0:
		return
	
	var random_obj: ObjectData = object_pool.pick_random()
	_context.battle_field.place_object(random_obj, empty_positions.pick_random())
	if track_achievement:
			Events.object_placed.emit(random_obj)
	
	await _context.battle_field.get_tree().create_timer(0.15).timeout
