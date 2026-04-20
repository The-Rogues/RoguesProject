extends Action
class_name MoveBehindTypeAction

@export var target_type: ObjectData.MoveTargetingCategory

func execute(_context:BattleContext = null, _user:AbstractEntity = null):
	var player = _context.creature_manager.player
	await player.movement_controller.move_behind_object_type(target_type)
	await _context.battle_field.get_tree().create_timer(0.15).timeout
