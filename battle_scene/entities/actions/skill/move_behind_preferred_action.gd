extends MovePlayerAction
class_name MoveBehindPreferredAction

func execute(_context:BattleContext = null, _user:AbstractEntity = null):
	var player = _context.creature_manager.player
	await player.movement_controller.move_behind_perferred_object()
	await _context.battle_field.get_tree().create_timer(0.15).timeout
