extends Action
class_name FrenzyAction

func execute(_context:BattleContext = null, _user:AbstractEntity = null):
	if _user is not PlayerEntity:
		return
	var player_position: BattlePosition = _user.battle_position
	var num_moves: int = 0
	await _user.movement_controller.move_behind_object_type(ObjectData.MoveTargetingCategory.WEAPON)
	while player_position != _user.battle_position:
		if _user.battle_position.get_object() != null:
			_user.battle_position.get_object().object_stat_display.interaction_button.disabled = true
			_user.battle_position.get_object().object_stat_display.interaction_button.visible = false
			for i in range(0, _user.battle_position.get_object().data.interaction_actions.size()):
				await _user.battle_position.get_object().data.interaction_actions[i].execute(_context, _user)
		num_moves += 1
		await _user.get_tree().create_timer(0.2).timeout
		player_position = _user.battle_position
		await _user.movement_controller.move_behind_object_type(ObjectData.MoveTargetingCategory.WEAPON)
	
	if num_moves == 0:
		if _user.battle_position.get_object() != null && _user.battle_position.get_object().data.targeting_categories.has(ObjectData.MoveTargetingCategory.WEAPON):
			_user.battle_position.get_object().object_stat_display.interaction_button.disabled = true
			_user.battle_position.get_object().object_stat_display.interaction_button.visible = false
			for i in range(0, _user.battle_position.get_object().data.interaction_actions.size()):
				await _user.battle_position.get_object().data.interaction_actions[i].execute(_context, _user)
	await _user.get_tree().create_timer(0.2).timeout
