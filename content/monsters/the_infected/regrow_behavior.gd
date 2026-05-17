extends NormalMonsterBehaviour
class_name RegrowBehaviour

## Enemy uses a special move when below a certain health

@export var health_threshold:int = 15
@export var basic_sequence: MoveSequence
@export var low_health_sequence: MoveSequence   

func decide_next_action(monster: MonsterEntity):
	if monster.health.value <= health_threshold and monster.move_sequence == basic_sequence:
		monster.move_index = 0
		monster.move_sequence = low_health_sequence
	else:
		super.decide_next_action(monster)
	
	monster.intent = monster.move_sequence.moves[monster.move_index]
