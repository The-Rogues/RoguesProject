extends MovePlayerAction
class_name DirectionalMoveAction

enum Direction { LEFT, RIGHT }
@export var direction: Direction
@export var num_spaces: int


func execute(_context:BattleContext = null, _user:AbstractEntity = null):
	var player = _context.creature_manager.player
	if direction == Direction.LEFT:
		await player.movement_controller.move_player_left(num_spaces)
	else:
		await player.movement_controller.move_player_right(num_spaces)
	await _context.battle_field.get_tree().create_timer(0.15).timeout
