extends StatusEffectBehaviour
class_name ScaredStatusEffect


const FAIL_CHANCE = 0.25


func on_stack(
	instance:ActiveStatusEffect, 
	_other:ActiveStatusEffect = null
) -> void:
	instance.duration += 1


func get_description(_instance:ActiveStatusEffect) -> String:
	return "When attacking, has a % chance to become Scared Stiff and fail."


func get_texture() -> Texture2D:
	return load("res://Entities/StatusEffects/EffectIcons/scared_effect_icon.tres")


func can_execute_action(
	_action:BattleAction, 
	_instance:ActiveStatusEffect = null
) -> bool:
	if _action is not AttackAction:
		return true
	
	
	if randf() <= FAIL_CHANCE:
		return false
	
	return true
