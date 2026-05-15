extends StatusEffectBehaviour
class_name RageEffect


func on_stack(
	instance:ActiveStatusEffect, 
	_other:ActiveStatusEffect = null,
	_affected: AbstractCreature = null
) -> void:
	instance.duration = -1 
	instance.stack += _other.stack
	if instance.stack == 0:
		_affected.effects.active_effects.erase(instance)
		_affected.stat_display.status_effect_container.icons[instance].queue_free()
		_affected.stat_display.status_effect_container.icons.erase(instance)


func get_status_name() -> String:
	return "Rage"


func get_description(instance:ActiveStatusEffect) -> String:
	return "Increase melee attack damage by 2 for each stack. If offense becomes 1, remove all rage."


func get_texture() -> Texture2D:
	return load("res://content/cards/brute_cards/rage_effect/rage_icon.tres")


func modify_attack_damage(damage:int, _instance:ActiveStatusEffect) -> int:
	return damage + (_instance.stack * 2)
