extends TargetedAction
class_name ApplyStatusAction

@export var effect:StatusEffectConfig

func execute(_context:BattleContext = null, _user:AbstractEntity = null):
	for target in resolved_targets:
		if !target:
			continue
		
		if target is AbstractCreature:
			if target is PlayerEntity:
				if ignore_foreground:
					target.apply_status_effect(effect, true)
				else:
					target.apply_status_effect(effect, false)
			else:
				target.apply_status_effect(effect)
			await action_resolve_delay()
