extends AttackAction
class_name StatusAttackAction


@export var status_effect:StatusEffectConfig


func execute(_context:BattleContext = null, _user:AbstractEntity = null):
	super(_context, _user)
	
	
	for target in resolved_targets:
		if !is_instance_valid(target):
			return
		if target is AbstractCreature:
			target.apply_status_effect(status_effect)
