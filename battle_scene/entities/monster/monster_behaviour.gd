@abstract
extends Resource
class_name MonsterBehaviour

## Chooses next move in sequence. If Sequence is completed, picks a random Sequnce and first move in Sequence.
@abstract
func decide_next_action(monster:MonsterEntity)
