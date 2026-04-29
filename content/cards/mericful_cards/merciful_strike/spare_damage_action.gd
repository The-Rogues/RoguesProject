extends DamageAction
class_name SpareDamageAction

@export var damage_amount: int = 0
@export var spare_amount: int = 0


func execute(_context:BattleContext = null, _user:AbstractEntity = null):
	
	for target in resolved_targets:
		if !target:
			continue
		
		if target.health.value <= spare_amount && !(target is ObjectEntity):
			target.health.kill()
			await action_resolve_delay()
		else:
			amount = _user.effects.apply_attack_damage_effects(damage_amount)
			super(_context, _user)
