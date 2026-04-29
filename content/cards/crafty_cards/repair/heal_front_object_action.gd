extends HealAction
class_name HealFrontObjectAction

func execute(_context:BattleContext = null, _user:AbstractEntity = null):
	if _user is not PlayerEntity:
		return
	if _user.battle_position.get_object() == null:
		return
	
	var target_object: ObjectEntity = _user.battle_position.get_object()
	if (amount + target_object.health.value) > target_object.health.max_value:
		target_object.health.max_value = amount + target_object.health.value
	
	resolved_targets.clear()
	resolved_targets.append(target_object)
	super(_context, _user)
