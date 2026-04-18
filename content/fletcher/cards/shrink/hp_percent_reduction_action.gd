extends TargetedAction
class_name HpPercentReductionAction

@export var percent: float = 0.5


func execute(_context:BattleContext = null, _user:AbstractEntity = null):
	
	for target in resolved_targets:
		if !target:
			continue
		
		target.take_damage(floor(target.health.value * percent), _user)
		await action_resolve_delay()
