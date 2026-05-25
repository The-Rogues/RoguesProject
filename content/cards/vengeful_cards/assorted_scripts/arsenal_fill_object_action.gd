extends Action
class_name ArsenalFillObjectAction

@export var fill_object_1: ObjectData
@export var fill_object_2: ObjectData
 
func execute(_context:BattleContext = null, _user:AbstractEntity = null):
	for i in range(0, _context.battle_field.battle_positions.size()):
		if _context.battle_field.battle_positions[i].get_object() == null:
			var fill_object: ObjectData = fill_object_1
			if randf() < 0.5:
				fill_object = fill_object_2 
			_context.battle_field.place_object(
				fill_object,
				_context.battle_field.battle_positions[i]
			)
	if _context.get_player().battle_position.get_object().data.targeting_categories.has(ObjectData.MoveTargetingCategory.WEAPON):
		_context.get_player().battle_position.get_object().object_stat_display.interaction_button.visible = true
