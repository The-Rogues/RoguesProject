extends DamageAction
class_name AttackAction

@export_range(1, 99) var base_damage:int
@export_range(1, 99) var hits:int = 1


func execute(_context:BattleContext = null, _user:AbstractEntity = null):
	amount = base_damage
	
	if _user is AbstractCreature:
		amount = _user.effects.apply_attack_damage_effects(amount)
	
	for i in range(0, hits):
		await super(_context, _user)
