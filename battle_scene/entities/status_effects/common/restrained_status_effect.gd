extends StatusEffectBehaviour
class_name RestrainedEffect


func on_stack(
	instance:ActiveStatusEffect, 
	_other:ActiveStatusEffect = null
) -> void:
	instance.duration += 1


func get_status_name() -> String:
	return "Restrained"


func get_description(_instance:ActiveStatusEffect) -> String:
	return "Decreases attack damage by half."


func get_texture() -> Texture2D:
	return load("res://battle_scene/entities/status_effects/common/restrained_icon.tres")


func modify_attack_damage(damage:int, _instance:ActiveStatusEffect) -> int:
	return roundi(damage * 0.5)
