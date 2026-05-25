extends Action
class_name DragonTurtleEvaluateAction

var offense_variation: EnemyMove = preload("res://content/monsters/crawler/moves/withdraw.tres")
var defense_variation: EnemyMove = preload("res://content/monsters/crawler/moves/spin.tres")
var strategy_variation: EnemyMove = preload("res://content/monsters/crawler/moves/ground_shake.tres")

func execute(_context:BattleContext = null, _user:AbstractEntity = null):
	if _user is MonsterEntity:
		var weight_values: Array[int] = [
			_context.get_player().offensive_trait.weight_value,
			_context.get_player().defensive_trait.weight_value,
			_context.get_player().strategic_trait.weight_value
		]
		var highest_weight: int = weight_values[0]
		for i in range(0, 3):
			if weight_values[i] > highest_weight:
				highest_weight = weight_values[i]
		var filtered_traits: Array[int] = []
		for i in range(0, 3):
			if weight_values[i] == highest_weight:
				filtered_traits.append(i)
		match filtered_traits.pick_random():
			0:
				_context.get_player().offensive_trait.set_weight(
					_context.get_player().offensive_trait.weight_value - 1
				)
				_user.move_sequence.moves.append(offense_variation)
				var thorns: StatusEffectConfig = StatusEffectConfig.new()
				thorns.behaviour = ThornsStatusEffectBehaviour.new()
				thorns.stack = 1
				thorns.duration = -1
				thorns.turn_entered = true
				_user.apply_status_effect(thorns)
			1:
				_context.get_player().defensive_trait.set_weight(
					_context.get_player().defensive_trait.weight_value - 1
				)
				_user.move_sequence.moves.append(defense_variation)
				var strength: StatusEffectConfig = StatusEffectConfig.new()
				strength.behaviour = StrengthEffect.new()
				strength.stack = 1
				strength.duration = -1
				strength.turn_entered = false
				_user.apply_status_effect(strength)
			2:
				_context.get_player().strategic_trait.set_weight(
					_context.get_player().strategic_trait.weight_value - 1
				)
				_user.move_sequence.moves.append(strategy_variation)
				var armor: StatusEffectConfig = StatusEffectConfig.new()
				armor.behaviour = ArmorEffect.new()
				armor.stack = 2
				armor.duration = -1
				armor.turn_entered = false
				_user.apply_status_effect(armor)
