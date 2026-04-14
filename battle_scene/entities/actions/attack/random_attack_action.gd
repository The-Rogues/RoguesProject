extends DamageAction
class_name RandomAttackAction

@export_range(1, 99) var max_damage:int = 9
@export_range(1, 99) var base_damage:int = 4
@export_range(1, 99) var hits:int = 1


func execute(_context:BattleContext = null, _user:AbstractEntity = null):
	amount = randi_range(base_damage, max_damage)
	
	if _user is AbstractCreature:
		amount = _user.effects.apply_attack_damage_effects(amount)
	
	for i in range(0, hits):
		super(_context, _user)
