extends BattleAction
class_name ClearStatusAction

func _execute(battle_instance:BattleManager, action_user:BattleEntity):
	action_user.status_conditions.clear_status_effects()
