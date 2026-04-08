extends TargetedAction
class_name BlockAction

@export var amount:int


func execute(_context:BattleContext = null, _user:AbstractEntity = null):
	for target in resolved_targets:
		if !target:
			continue
		
		if target is AbstractCreature:
			target.block.add_block(amount)
			await action_resolve_delay()
