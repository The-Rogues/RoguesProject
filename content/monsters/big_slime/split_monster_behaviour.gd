extends MonsterBehaviour
class_name HealthThresholdMonsterBehaviour
## Enemy chooses an action the same action when below a certain amount of health

@export var health_threshold:int = 20
@export var primary_action:Action
@export var secondary_action:Action


func decide_next_action(monster:MonsterEntity):
	if monster.health.value <= health_threshold:
		var sequence = MoveSequence.new()
		sequence.moves.append(primary_action)
		sequence.moves.append(secondary_action)
		monster.move_index = 0
		monster.move_sequence = sequence
	else:
		super(monster)
	
	monster.intent = monster.move_sequence.moves[monster.move_index]
