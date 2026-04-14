extends StatusEffectBehaviour
class_name WoundedStatusEffect


func on_stack(
	instance:ActiveStatusEffect, 
	_other:ActiveStatusEffect = null
) -> void:
	instance.duration += 1


func get_description(_instance:ActiveStatusEffect) -> String:
	return "Prevents Healing this turn."


func get_texture() -> Texture2D:
	return load("res://battle_scene/entities/status_effects/common/wounded_icon.tres")


func can_execute_action(
	_action:Action, 
	_instance:ActiveStatusEffect = null
) -> bool:
	if _action is HealAction:
		return false
	
	return true
