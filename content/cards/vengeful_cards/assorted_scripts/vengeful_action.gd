extends AttackAction
class_name VengefulAction

enum EffectType {
	PAYBACK,
	BLOODLASH,
	RETALIATE,
	ADDEFFECT
}

@export var effect_type: EffectType

@export var boosted_damage:int = 12
@export var bonus_hits:int = 2
@export var refund_energy:int = 1

@export var conditional_effect: Action

func execute(_context:BattleContext = null, _user:AbstractEntity = null):
	match effect_type:
		
		EffectType.PAYBACK:
			if _user.damage_taken_last_turn > 0:
				base_damage = boosted_damage
		
		EffectType.BLOODLASH:
			if _user.damage_taken_last_turn > 0:
				hits = bonus_hits
		
		EffectType.RETALIATE:
			if _user.damage_taken_last_turn > 0:
				_user.energy.replenish(refund_energy)
		
		EffectType.ADDEFFECT:
			if _user.damage_taken_last_turn > 0:
				await super.execute(_context, _user)
				conditional_effect.resolved_targets = resolved_targets
				await conditional_effect.execute(_context, _user)
				return
	
	await super.execute(_context, _user)
