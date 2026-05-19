extends DamageAction
class_name UnstableAttackAction

@export_range(1, 99) var base_damage:int
@export_range(1, 99) var hits:int = 1


func execute(_context:BattleContext = null, _user:AbstractEntity = null):
	amount = base_damage
	
	if _user is AbstractCreature:
		amount = _user.effects.apply_attack_damage_effects(amount)
	
	for i in range(0, hits):
		await super(_context, _user)
	
	if randf() < 0.5:
		if is_instance_valid(_user):
			_user.health.kill()
		await _context.creature_manager.get_tree().create_timer(1.0).timeout
