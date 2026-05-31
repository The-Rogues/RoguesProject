extends Action
class_name ChestOpenAction

func execute(_context:BattleContext = null, _user:AbstractEntity = null):
	if _user is not PlayerEntity:
		return
	if _user.battle_position.get_object() && _user.battle_position.get_object().data.name == "Chest":
		_user.battle_position.get_object().object_stat_display.interaction_button.button_up.emit()
