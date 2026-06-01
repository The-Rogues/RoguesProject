extends StatusEffectBehaviour
class_name WarMachineEffect

func on_stack(
	instance:ActiveStatusEffect, 
	_other:ActiveStatusEffect = null,
	_affected: AbstractCreature = null
) -> void:
	instance.duration = -1
	instance.stack += _other.stack

func get_status_name() -> String:
	return "Power: War Machine"

func get_description(_instance:ActiveStatusEffect) -> String:
	return "On Turn Entered: Gain [color=#43A047]" + str(2 * _instance.stack) + "[/color] [color=orange]rage[/color] and lose [color=#43A047]" + str(_instance.stack) + "[/color] [color=orange]offense[/color]."

func get_texture() -> Texture2D:
	return load("res://content/cards/brute_cards/war_machine_effect/power_icon.tres")

func on_turn(
	_creature:AbstractCreature = null,
	_instance:ActiveStatusEffect = null
) -> void:
	if _creature is PlayerEntity:
		var new_effect: StatusEffectConfig = StatusEffectConfig.new()
		new_effect.behaviour = RageEffect.new()
		new_effect.duration = -1
		new_effect.stack = _instance.stack * 2
		var effect_target: PlayerEntity = _creature as PlayerEntity
		effect_target.apply_status_effect(new_effect, true)
		if effect_target.offensive_trait.can_modify_next_turn:
			effect_target.offensive_trait.set_weight(
				effect_target.offensive_trait.weight_value - 1
			)
