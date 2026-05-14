extends StatusEffectBehaviour
class_name FortitudeEffect

func on_stack(
	instance:ActiveStatusEffect, 
	_other:ActiveStatusEffect = null,
	_affected: AbstractCreature = null
) -> void:
	instance.duration = -1
	instance.stack += 1

func get_status_name() -> String:
	return "Power: Fortitude"

func get_description(_instance:ActiveStatusEffect) -> String:
	if _instance.stack == 1:
		return "On Turn Entered: Lose 1 random stat point and gain 2 strength."
	else:
		return "On Turn Entered: Lose " + str(_instance.stack) + " random stat points and gain " + str(_instance.stack * 2) + " strength."

func get_texture() -> Texture2D:
	return load("res://content/cards/brute_cards/war_machine_effect/power_icon.tres")


func on_turn(
	_creature:AbstractCreature = null,
	_instance:ActiveStatusEffect = null
) -> void:
	if _creature is not PlayerEntity:
		return
	var player: PlayerEntity = _creature as PlayerEntity
	for i in range(0, _instance.stack):
		var personality_pool: Array[int] = []
		if player.offensive_trait.weight_value > 1:
			personality_pool.append(0)
		if player.defensive_trait.weight_value > 1:
			personality_pool.append(1)
		if player.strategic_trait.weight_value > 1:
			personality_pool.append(2)
		if personality_pool.size() == 0:
			return
		var decrease_trait: int = personality_pool.pick_random()
		var apply_strength: bool = false
		match decrease_trait:
			0:
				apply_strength = true
				if player.offensive_trait.can_modify_next_turn:
					player.offensive_trait.set_weight(
						player.offensive_trait.weight_value - 1
					)
			1:
				apply_strength = true
				if player.defensive_trait.can_modify_next_turn:
					player.defensive_trait.set_weight(
						player.defensive_trait.weight_value - 1
					)
			2:
				apply_strength = true
				if player.strategic_trait.can_modify_next_turn:
					player.strategic_trait.set_weight(
						player.strategic_trait.weight_value - 1
					)
		if apply_strength:
			var strength_config: StatusEffectConfig = StatusEffectConfig.new()
			strength_config.behaviour = StrengthEffect.new()
			strength_config.stack = 2
			strength_config.duration = -1
			player.apply_status_effect(strength_config, true)
