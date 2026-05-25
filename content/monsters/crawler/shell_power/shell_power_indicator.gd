extends StatusEffectBehaviour
class_name ShellEffect

func on_stack(
	instance:ActiveStatusEffect, 
	_other:ActiveStatusEffect = null,
	_affected: AbstractCreature = null
) -> void:
	instance.stack += 1
	instance.duration = -1

func get_status_name() -> String:
	return "Shell"

func get_description(_instance:ActiveStatusEffect) -> String:
	return "Does not lose [color=orange]thorns[/color] or [color=orange]armor[/color]."

func get_texture() -> Texture2D:
	return load("res://content/cards/brute_cards/war_machine_effect/power_icon.tres")
