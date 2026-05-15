extends StatusEffectBehaviour
class_name ScaredStatusEffect


const FAIL_CHANCE = 0.5


func on_stack(
	instance:ActiveStatusEffect, 
	_other:ActiveStatusEffect = null,
	_affected: AbstractCreature = null
) -> void:
	instance.duration += 1


func get_status_name() -> String:
	return "Scared"


func get_description(_instance:ActiveStatusEffect) -> String:
	return "When attacking, has a 50% chance to become Scared Stiff and fail."


func get_texture() -> Texture2D:
	return load("res://battle_scene/entities/status_effects/common/scared_icon.tres")


func can_execute_action(
	_action:Action, 
	_instance:ActiveStatusEffect = null
) -> bool:
	if _action is not AttackAction:
		return true
	
	
	if randf() <= FAIL_CHANCE:
		return false
	
	return true
