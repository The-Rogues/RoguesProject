extends Action
class_name MovePlayerAction

enum DirectionOption {LEFT, RIGHT, RANDOM, PREFERRED}
@export var direction_choice:DirectionOption


func execute(_context:BattleContext = null, _user:AbstractEntity = null):
	var player = _context.creature_manager.player
	
	match direction_choice:
		DirectionOption.LEFT:
			player.movement_controller.move_left()
		DirectionOption.RIGHT:
			player.movement_controller.move_right()
		DirectionOption.RANDOM:
			if randf() <= 0.5:
				player.movement_controller.move_left()
			else:
				player.movement_controller.move_right()
		DirectionOption.PREFERRED:
			player.movement_controller.move_towards_nearest_object_position_by_role(
					player.data.personality.priority_trait.object_preference
			)
		_:
			if randf() <= 0.5:
				player.movement_controller.move_left()
			else:
				player.movement_controller.move_right()
	
	await player.movement_controller.entered_new_position
	await _context.battle_field.get_tree().create_timer(0.15).timeout
