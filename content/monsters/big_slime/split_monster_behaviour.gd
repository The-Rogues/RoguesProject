extends MonsterBehaviour
class_name SplitMonsterBehaviour


@export var health_threshold:int = 20
@export var split_move:EnemySpawn


func decide_next_action(monster:MonsterEntity):
	if monster.health.value <= health_threshold:
		var sequence = MoveSequence.new()
		sequence.moves.append(split_move)
		monster.move_index = 0
		monster.move_sequence = sequence
	else:
		super(monster)
	
	monster.intent = monster.move_sequence.moves[monster.move_index]
