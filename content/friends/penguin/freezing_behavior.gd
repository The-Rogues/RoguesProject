extends StatusEffectBehaviour
class_name FreezingBehavior

func on_stack(
	instance:ActiveStatusEffect, 
	_other:ActiveStatusEffect = null,
	_affected: AbstractCreature = null
) -> void:
	instance.stack += _other.stack
	instance.duration = -1
	_affected.take_damage(instance.stack)

func get_status_name() -> String:
	return "Freezing"

func get_description(_instance:ActiveStatusEffect) -> String:
	return "Whenever [color=orange]freezing[/color] is applied, takes damage equal to total [color=orange]freezing[/color]."

func get_texture() -> Texture2D:
	return load("res://content/friends/penguin/cold_icon.png.png")

func on_apply(_creature:AbstractCreature, _instance:ActiveStatusEffect) -> void:
	_creature.take_damage(_instance.stack)
