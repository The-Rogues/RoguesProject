extends DamageAction
class_name RatAttackAction

const RAT_DAMAGE = 4

func execute(_context:BattleContext = null, _user:AbstractEntity = null):
	if _user is not PlayerEntity:
		return
	
	var effect = _context.creature_manager.player.effects.get_effect(
			RatStatusEffect)
	
	amount = RAT_DAMAGE
	
	if effect:
		for i in range(0, effect.stack):
			super(_context, _user)
