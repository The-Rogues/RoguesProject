@abstract
extends TargetedAction
class_name DamageAction

var amount:int


func execute(_context:BattleContext = null, _user:AbstractEntity = null):
	
	for target in resolved_targets:
		if !target:
			continue
		
		target.take_damage(amount, _user)
		await action_resolve_delay()
