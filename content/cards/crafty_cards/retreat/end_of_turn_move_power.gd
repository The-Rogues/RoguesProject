extends BattlePower
class_name EndOfTurnMovePower

func on_apply(_context:BattleContext):
	pass

func on_turn_ended(_context: BattleContext):
	_context.get_player().movement_controller.move_behind_object_type(
		ObjectData.MoveTargetingCategory.COVER
	)
	end_power()
