extends Script
class_name MonsterBehaviour

## Chooses next move in sequence. If Sequence is completed, picks a random Sequnce and first move in Sequence.
func decide_next_action(monster:MonsterEntity):
	monster.move_index += 1
	
	if monster.move_index == monster.move_sequence.actions.size():
		monster.move_sequence = monster.data.move_sequences.pick_random()
		monster.move_index = 0
	
	monster.intent = monster.move_sequence.actions[monster.move_index]
