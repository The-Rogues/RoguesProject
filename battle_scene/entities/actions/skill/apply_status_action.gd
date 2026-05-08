extends TargetedAction
class_name ApplyStatusAction

@export var effect:StatusEffectConfig

func execute(_context:BattleContext = null, _user:AbstractEntity = null):
	for target in resolved_targets:
		if !target:
			continue
		
		if target is AbstractCreature:
			if !ignore_foreground:
				target.apply_status_effect(effect)
				await action_resolve_delay()
			else:
				target.apply_status_effect(effect, true)
				await action_resolve_delay()
