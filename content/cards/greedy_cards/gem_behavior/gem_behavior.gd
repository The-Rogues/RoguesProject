extends StatusEffectBehaviour
class_name GemEffect


func on_stack(
	instance:ActiveStatusEffect, 
	_other:ActiveStatusEffect = null,
	_affected: AbstractCreature = null
) -> void:
	instance.stack += _other.stack
	instance.duration = -1


func get_status_name() -> String:
	return "Gem"


func get_description(_instance:ActiveStatusEffect) -> String:
	return "If you have 5 or more gems at the end of combat, gain an extra gold reward."


func get_texture() -> Texture2D:
	return load("res://content/cards/greedy_cards/assets/gem_icon.tres")
