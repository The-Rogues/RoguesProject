extends StatusEffectBehaviour
class_name StrengthEffect


func on_stack(
	instance:ActiveStatusEffect, 
	_other:ActiveStatusEffect = null
) -> void:
	instance.duration += 1
	instance.stack += _other.stack


func get_description(instance:ActiveStatusEffect) -> String:
	return "Increase Attack Damage by " + str(instance.stack) + "." 


func get_texture() -> Texture2D:
	return load("res://battle_scene/entities/status_effects/common/strength_icon.tres")


func modify_attack_damage(damage:int, _instance:ActiveStatusEffect) -> int:
	return damage + _instance.stack
