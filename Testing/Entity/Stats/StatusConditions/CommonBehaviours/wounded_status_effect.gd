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
	return load("res://Entities/StatusEffects/EffectIcons/wounded_effect_icon.tres")


func can_execute_action(
	_action:BattleAction, 
	_instance:ActiveStatusEffect = null
) -> bool:
	if _action is SkillAction:
		if _action.effect == SkillAction.SkillEffect.HEAL:
			return false
	
	return true
