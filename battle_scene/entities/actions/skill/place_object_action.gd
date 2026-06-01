extends Action
class_name PlaceObjectAction

@export var object:ObjectData
@export var secondary_action:Action

func execute(_context:BattleContext = null, _user:AbstractEntity = null):
	var track_achievement: bool = false
	if _user is PlayerEntity:
		track_achievement = true
	if _context.battle_field.place_object(object):
		if track_achievement:
			Events.object_placed.emit(object)
		await _context.battle_field.get_tree().create_timer(0.15).timeout
		if secondary_action:
			if secondary_action is TargetedAction:
				secondary_action.resolved_targets = _context.resolve_targeting.call(
						secondary_action, _user)
			secondary_action.execute(_context, _user)
	else:
		await _context.battle_field.get_tree().create_timer(0.15).timeout
