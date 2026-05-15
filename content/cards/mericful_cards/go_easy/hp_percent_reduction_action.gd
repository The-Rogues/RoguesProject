extends TargetedAction
class_name HpPercentReductionAction

@export var percent: float = 0.5


func execute(_context:BattleContext = null, _user:AbstractEntity = null):
	
	for target in resolved_targets:
		if !target:
			continue
		
		target.health.value = target.health.value - floor(target.health.value * percent)
		target.health.health_changed.emit(target.health.value, target.health.max_value)
		await action_resolve_delay()
