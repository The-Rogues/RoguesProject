extends StatusEffectBehaviour
class_name VulnerableEffect


func on_stack(
	instance:ActiveStatusEffect, 
	_other:ActiveStatusEffect = null
) -> void:
	instance.duration += 1


func get_description(_instance:ActiveStatusEffect) -> String:
	return "Increases damage recieved from attacks by Half"


func get_texture() -> Texture2D:
	return load("res://Entities/StatusEffects/Vulnerable/vulnerable_status_effect_texture.tres")


func modify_incoming_damage(damage:int, _instance:ActiveStatusEffect) -> int:
	return roundi(damage * 1.5)
