extends MovePlayerAction
class_name MoveTowardPreferrenceAction

@export var num_spaces: int

func execute(_context:BattleContext = null, _user:AbstractEntity = null):
	var player = _context.creature_manager.player
	await player.movement_controller.move_toward_perfered_object(num_spaces)
	await _context.battle_field.get_tree().create_timer(0.15).timeout
