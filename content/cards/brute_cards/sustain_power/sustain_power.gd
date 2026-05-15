extends BattlePower
class_name SustainPower

var turn_end_counter: int = 0

func on_apply(_context:BattleContext):
	_context.get_player().offensive_trait.can_modify_next_turn = false

func on_turn_entered(_context:BattleContext):
	var sustain_effect: StatusEffectConfig = StatusEffectConfig.new()
	sustain_effect.behaviour = NextOffenseIndicator.new()
	sustain_effect.turn_entered = false
	_context.get_player().apply_status_effect(sustain_effect, true)
	_context.get_player().offensive_trait.can_modify_next_turn = true
	_context.get_player().offensive_trait.can_modify_this_turn = false

func on_turn_ended(_context: BattleContext):
	turn_end_counter += 1
	if turn_end_counter == 2:
		_context.get_player().offensive_trait.can_modify_this_turn = true
		end_power()
