extends TargetedAction
class_name ApplyMultiStatusAction

@export var effects: Array[StatusEffectConfig]

func execute(_context:BattleContext = null, _user:AbstractEntity = null):
	for target in resolved_targets:
		if !target:
			continue
		
		if target is AbstractCreature:
			for i in range(0, effects.size()):
				if target is PlayerEntity:
					if ignore_foreground:
						target.apply_status_effect(effects[i], true)
					else:
						target.apply_status_effect(effects[i], false)
				else:
					if ignore_foreground:
						target.apply_status_effect(effects[i])
					elif _user is PlayerEntity && _user.battle_position.get_object() == null:
						target.apply_status_effect(effects[i])
					elif _user is PlayerEntity && _user.battle_position.get_object() != null && _user.battle_position.get_object().health.value == 0:
						target.apply_status_effect(effects[i])
	await action_resolve_delay()
