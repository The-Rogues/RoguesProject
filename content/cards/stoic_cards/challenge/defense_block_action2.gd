extends BlockAction
class_name DefenseBlockAction

@export var block_multiplier: int = 1
@export var def_increment: int = 1

func execute(_context:BattleContext = null, _user:AbstractEntity = null):
	if resolved_targets.size() != 1:
		return
	
	if resolved_targets[0] is PlayerEntity:
		amount = resolved_targets[0].defensive_trait.weight_value / def_increment 
		amount *= block_multiplier
	else:
		return
	
	super(_context, _user)
