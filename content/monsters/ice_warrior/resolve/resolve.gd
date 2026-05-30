extends StatusEffectBehaviour
class_name ResloveEffect

var instance_ref: ActiveStatusEffect = null

func on_stack(
	instance:ActiveStatusEffect, 
	_other:ActiveStatusEffect = null,
	_affected: AbstractCreature = null
) -> void:
	instance.stack += _other.stack
	instance.duration = -1

func get_status_name() -> String:
	return "Resolve"

func get_description(_instance:ActiveStatusEffect) -> String:
	return "On Enemy Death: Gains [color=orange]strength[/color] equal to resolve."

func get_texture() -> Texture2D:
	return load("res://content/monsters/ice_warrior/resolve/resolve_icon.tres")
