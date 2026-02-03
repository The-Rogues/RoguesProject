extends AtomicAction
class_name MoveAction

enum DIRECTION {Left, Right, Random}
@export_range(1, 4) var steps:int = 1
@export var direction:DIRECTION

func execute(battle_info:BattleActionInfo):
	var dir:int = steps
	if direction == DIRECTION.Left:
		dir = -dir
	elif direction == DIRECTION.Right:
		pass
	elif direction == DIRECTION.Random:
		var rand = randf()
		
		if rand < 0.5:
			dir *= -1
	
	battle_info.battle_field.move_player(dir)
	await battle_info.battle_field.moved_position
