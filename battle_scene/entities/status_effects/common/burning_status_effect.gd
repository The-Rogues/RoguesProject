extends StatusEffectBehaviour
class_name BurningEffect


func on_stack(
	instance:ActiveStatusEffect, 
	_other:ActiveStatusEffect = null,
	_affected: AbstractCreature = null
) -> void:
	instance.duration += _other.duration


func get_status_name() -> String:
	return "Burning"


func get_description(_instance:ActiveStatusEffect) -> String:
	return "On Player Turn Ended: Takes damage equal to [color=orange]burning[/color]. [color=orange]Burning[/color] decreases by [color=#43A047]1[/color]."


func get_texture() -> Texture2D:
	return load("res://battle_scene/entities/status_effects/common/burning_icon.tres")


func on_turn(
	_creature:AbstractCreature = null,
	_instance:ActiveStatusEffect = null
) -> void:
	_creature.take_damage(_instance.duration, null)
