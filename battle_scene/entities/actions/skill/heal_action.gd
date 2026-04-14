extends TargetedAction
class_name HealAction

@export_range(1, 99) var amount:int = 1


func execute(_context:BattleContext = null, _user:AbstractEntity = null):
	for target in resolved_targets:
		target.health.heal(amount)
		await action_resolve_delay()
