extends BattlePower
class_name EndOfTurnBuildPower

func on_apply(_context:BattleContext):
	pass

func on_turn_ended(_context: BattleContext):
	if !_context.get_player().battle_position.get_object():
		var new_wall: ObjectData = load("res://content/objects/crafted_wall/crafted_wall.tres")
		Events.object_placed.emit(new_wall)
		_context.battle_field.place_object(
			new_wall,
			_context.get_player().battle_position
		)
	end_power()
