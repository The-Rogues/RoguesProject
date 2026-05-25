extends DamageAction
class_name AttackAction

@export_range(0, 100) var base_damage:int = 0
@export_range(1, 99) var hits:int = 1


func execute(_context:BattleContext = null, _user:AbstractEntity = null):
	if base_damage != 0:
		amount = base_damage
	
	if _user is AbstractCreature:
		amount = _user.effects.apply_attack_damage_effects(amount)
		if amount < 0:
			amount = 0
	
	if is_instance_valid(_user):
		for i in range(0, hits):
			if !is_instance_valid(_user):
				return
			await super(_context, _user)
		return
	if _user == null:
		for i in range(0, hits):
			if _user != null:
				return
			await super(_context, _user)
		return
