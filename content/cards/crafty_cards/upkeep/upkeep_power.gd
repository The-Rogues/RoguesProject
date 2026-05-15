extends BattlePower
class_name UpkeepPower

func on_apply(_context:BattleContext):
	pass

func on_turn_entered(_context:BattleContext):

	for i in range(0, _context.battle_field.battle_positions.size()):
		
		if _context.battle_field.battle_positions[i].get_object() == null:
			continue
		
		var target_object: ObjectEntity = _context.battle_field.battle_positions[i].get_object()
		if (5 + target_object.health.value) > target_object.health.max_value:
			target_object.health.max_value = 7 + target_object.health.value
			
		target_object.health.heal(7)
