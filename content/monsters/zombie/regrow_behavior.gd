extends MonsterBehaviour
class_name RegrowBehaviour

## Enemy uses a special move when below a certain health

@export var health_threshold:int = 15
@export var low_health_move: EnemyMove   

func decide_next_action(monster: MonsterEntity):
	if monster.health.value <= health_threshold and low_health_move != null:
		var sequence := MoveSequence.new()
		sequence.moves = [low_health_move]   
		
		monster.move_index = 0
		monster.move_sequence = sequence
	else:
		super.decide_next_action(monster)
	
	monster.intent = monster.move_sequence.moves[monster.move_index]
