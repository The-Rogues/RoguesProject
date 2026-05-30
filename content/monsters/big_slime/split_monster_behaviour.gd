extends NormalMonsterBehaviour
class_name HealthThresholdMonsterBehavior
## Enemy chooses an action the same action when below a certain amount of health

@export var health_threshold:int = 20
@export var move:EnemyMove


func decide_next_action(monster:MonsterEntity, in_context: BattleContext = null):
	if monster.health.value <= health_threshold:
		var sequence = MoveSequence.new()
		sequence.moves.append(move)
		monster.move_index = 0
		monster.move_sequence = sequence
	else:
		super(monster)
	
	monster.intent = monster.move_sequence.moves[monster.move_index]
