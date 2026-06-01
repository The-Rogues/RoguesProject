extends MonsterBehaviour
class_name InpuBehaviour

var is_init_sequence: bool = true

func decide_next_action(monster:MonsterEntity, _in_context: BattleContext = null):
	var has_anpu: bool = false
	for i in range(0, _in_context.creature_manager.enemies.size()):
		if _in_context.creature_manager.enemies[i].data.name == "Anpu":
			has_anpu = true
	
	if !has_anpu && is_init_sequence:
		monster.move_sequence = monster.data.move_sequences[1]
		monster.move_index = 0
		monster.intent = monster.move_sequence.moves[0]
		is_init_sequence = false
		return
		
	if monster.move_sequence == null:
		monster.move_sequence = monster.data.move_sequences[0]
		monster.move_index = 0
		monster.intent = monster.move_sequence.moves[0]
		return
	
	monster.move_index += 1
	
	if monster.move_index == monster.move_sequence.moves.size():
		if is_init_sequence:
			monster.move_sequence = monster.data.move_sequences[0]
			monster.move_index = 0
		else:
			monster.move_sequence = monster.data.move_sequences[2]
			monster.move_index = 0
	
	monster.intent = monster.move_sequence.moves[monster.move_index]
