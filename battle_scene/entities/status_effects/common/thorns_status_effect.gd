extends StatusEffectBehaviour
class_name ThornsStatusEffectBehaviour


func on_stack(
	instance:ActiveStatusEffect, 
	_other:ActiveStatusEffect = null
) -> void:
	instance.stack += _other.stack
	instance.duration += 1


func get_status_name() -> String:
	return "Thorns"


func get_description(_instance:ActiveStatusEffect) -> String:
	return "Deals " + str(_instance.stack) + " damage when attacked."


func get_texture() -> Texture2D:
	return load("res://battle_scene/entities/status_effects/common/thorns_icon.tres")


func on_attacked(_attacker:AbstractEntity, _instance:ActiveStatusEffect):
	_attacker.take_damage(_instance.stack, null)
