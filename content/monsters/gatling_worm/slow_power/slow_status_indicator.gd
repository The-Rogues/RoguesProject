extends StatusEffectBehaviour
class_name SlowStatusIndicator

func on_stack(
	instance:ActiveStatusEffect, 
	_other:ActiveStatusEffect = null,
	_affected: AbstractCreature = null
) -> void:
	instance.stack += 1
	instance.duration = -1

func get_status_name() -> String:
	return "Slow"

func get_description(_instance:ActiveStatusEffect) -> String:
	return "On Player Move: Gains [color=#43A047]1[/color] [color=orange]dazed[/color]."

func get_texture() -> Texture2D:
	return load("res://content/monsters/gatling_worm/slow_power/slow_icon.tres")
