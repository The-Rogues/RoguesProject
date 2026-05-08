extends BlockAction
class_name DefenseBlockAction

func execute(_context:BattleContext = null, _user:AbstractEntity = null):
	if resolved_targets.size() != 1:
		return
	
	if resolved_targets[0] is PlayerEntity:
		amount = resolved_targets[0].defensive_trait.weight_value
	else:
		return
	
	super(_context, _user)
