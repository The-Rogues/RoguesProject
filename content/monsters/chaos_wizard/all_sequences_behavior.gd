extends MonsterBehaviour
class_name AllSequencesBehaviour

@export var num_sequences: int
var remaining_sequences: Array[int] = []

func decide_next_action(monster:MonsterEntity, _in_context: BattleContext = null):
	
	if remaining_sequences.size() == 0:
		for i in range(0, num_sequences):
			remaining_sequences.append(i)
	
	if monster.move_sequence == null:
		
		var rand_idx: int = remaining_sequences.pick_random()
		remaining_sequences.erase(rand_idx)
		
		monster.move_sequence = monster.data.move_sequences[rand_idx]
		monster.move_index = 0
		monster.intent = monster.move_sequence.moves[0]
		return
	
	monster.move_index += 1
	print(remaining_sequences)
	
	if monster.move_index == monster.move_sequence.moves.size():
		
		var rand_idx: int = remaining_sequences.pick_random()
		remaining_sequences.erase(rand_idx)
		
		monster.move_sequence = monster.data.move_sequences[rand_idx]
		monster.move_index = 0
	
	monster.intent = monster.move_sequence.moves[monster.move_index]
