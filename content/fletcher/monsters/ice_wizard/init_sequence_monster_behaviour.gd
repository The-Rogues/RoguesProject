extends MonsterBehaviour
class_name InitSequenceBehavior
## Does first move set once.

func decide_next_action(monster:MonsterEntity):
	if monster.move_sequence == null && monster.move_index == 0:
		monster.move_sequence = monster.data.move_sequences[0]
		monster.move_index = 0
		monster.intent = monster.move_sequence.moves[0]
		return
	
	monster.move_index += 1
	
	if monster.move_index == monster.move_sequence.moves.size():
		#print("Here")
		monster.move_sequence = monster.data.move_sequences[1]
		monster.move_index = 0
	
	monster.intent = monster.move_sequence.moves[monster.move_index]
