extends StatusEffectBehaviour
class_name NextOffenseIndicator

func on_stack(
	instance:ActiveStatusEffect, 
	_other:ActiveStatusEffect = null,
	_affected: AbstractCreature = null
) -> void:
	instance.stack = 1
	instance.duration = 1

func get_status_name() -> String:
	return "Special: Sustain"

func get_description(_instance:ActiveStatusEffect) -> String:
	return "This turn, you can't lose offense."

func get_texture() -> Texture2D:
	return load("res://content/cards/brute_cards/war_machine_effect/power_icon.tres")
