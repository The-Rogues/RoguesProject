extends AttackAction
class_name DamageScaleAction

# Fabian - Tried to replicate behaviour scripted in EnemyDamageScale
# Resources are shared data containers. So all enemies who use this attack
# will scale eachothers damage.

@export var init_damage: int
@export var scale_value: int

func execute(_context:BattleContext = null, _user:AbstractEntity = null):
	amount = init_damage
	init_damage += scale_value
	
	if _user is AbstractCreature:
		amount = _user.effects.apply_attack_damage_effects(amount)
	
	for i in range(0, hits):
		for target in resolved_targets:
			if !target:
				continue
			
			target.take_damage(amount, _user)
			await action_resolve_delay()
