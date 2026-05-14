extends Action
class_name ActivateWeaponTwiceAction

func execute(_context:BattleContext = null, _user:AbstractEntity = null):
	if _user is not PlayerEntity:
		return
	if _user.battle_position.get_object() == null:
		return
	if _user.battle_position.get_object().health.value == 0:
		return
	if !_user.battle_position.get_object().data.targeting_categories.has(ObjectData.MoveTargetingCategory.WEAPON):
		return
	await _user.get_tree().process_frame
	_user.battle_position.get_object().object_stat_display.interaction_button.disabled = true
	_user.battle_position.get_object().object_stat_display.interaction_button.visible = false
	var twice_actions: Array[Action] = _user.battle_position.get_object().data.interaction_actions
	for i in range(0, 2):
		for j in range(0, twice_actions.size()):
			await twice_actions[j].execute(_context, _user)
		await _user.get_tree().create_timer(0.3).timeout
