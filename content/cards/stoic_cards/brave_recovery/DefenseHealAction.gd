extends HealAction
class_name DefenseHealAction

func execute(_context:BattleContext = null, _user:AbstractEntity = null):
	if resolved_targets.size() != 1:
		return
	if resolved_targets[0] is not PlayerEntity:
		return
	amount = resolved_targets[0].defensive_trait.weight_value
	super(_context, _user)
