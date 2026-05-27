extends Action
class_name FrontPlaceAction

@export var object: ObjectData

func execute(_context:BattleContext = null, _user:AbstractEntity = null):
	if _context.get_player().battle_position.get_object() != null:
		return
	_context.battle_field.place_object(object, _context.get_player().battle_position)
	
	if _context.get_player().battle_position.get_object().data.targeting_categories.has(ObjectData.MoveTargetingCategory.WEAPON):
		_context.get_player().battle_position.get_object().object_stat_display.interaction_button.visible = true
		
	await _context.battle_field.get_tree().create_timer(0.15).timeout
