extends Action
class_name FrontPlaceAction

@export var object: ObjectData

func execute(_context:BattleContext = null, _user:AbstractEntity = null):
	
	var track_achievement: bool = false
	if _user is PlayerEntity:
		track_achievement = true
	
	if _context.get_player().battle_position.get_object() != null && _context.get_player().battle_position.get_object().health.is_alive:
		return
	
	_context.battle_field.place_object(object, _context.get_player().battle_position)
	if track_achievement:
			Events.object_placed.emit(object)
	await _context.battle_field.get_tree().create_timer(0.15).timeout
