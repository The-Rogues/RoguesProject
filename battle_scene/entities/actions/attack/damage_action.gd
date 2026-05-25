@abstract
extends TargetedAction
class_name DamageAction

var amount:int = 0


func execute(_context:BattleContext = null, _user:AbstractEntity = null):
	
	for target in resolved_targets:
		if !target:
			continue
		if ignore_foreground:
			target.take_damage(amount, _user, true)
		else:
			target.take_damage(amount, _user)
		await action_resolve_delay()
