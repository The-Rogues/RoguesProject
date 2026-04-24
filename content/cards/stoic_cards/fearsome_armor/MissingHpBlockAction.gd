extends BlockAction
class_name MissingHpBlockAction

func execute(_context:BattleContext = null, _user:AbstractEntity = null):
	
	if resolved_targets.size() != 1:
		return
	
	if resolved_targets[0] is MonsterEntity || resolved_targets[0] is PlayerEntity:
		var missing_hp: int = resolved_targets[0].health.max_value - resolved_targets[0].health.value
		amount = missing_hp
		resolved_targets[0] = _user
	else:
		return
	
	super(_context, _user)
