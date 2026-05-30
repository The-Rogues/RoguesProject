extends BattlePower
class_name ImmunityPower

func on_apply(_context:BattleContext):
	_context.get_player().effects.effect_added.connect(enable_immunity)
	_context.get_player().effects.effect_changed.connect(enable_immunity)

func enable_immunity(target_effect: ActiveStatusEffect):
	if target_effect.effect is InfectedBehavior:
		target_effect.effect.is_immune = true
