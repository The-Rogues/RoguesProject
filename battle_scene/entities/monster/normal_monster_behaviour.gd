extends MonsterBehaviour
class_name NormalMonsterBehaviour

## Chooses next move in sequence. If Sequence is completed, picks a random Sequnce and first move in Sequence.
func decide_next_action(monster:MonsterEntity, _in_context: BattleContext = null):
	if monster.move_sequence == null:
		monster.move_sequence = monster.data.move_sequences.pick_random()
		monster.move_index = 0
		monster.intent = monster.move_sequence.moves[0]
		return
	
	monster.move_index += 1
	
	if monster.move_index == monster.move_sequence.moves.size():
		monster.move_sequence = monster.data.move_sequences.pick_random()
		monster.move_index = 0
	
	monster.intent = monster.move_sequence.moves[monster.move_index]
