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
	return "Increase melee attack damage by [color=#43A047]2[/color] for each stack. If [color=orange]offense[/color] becomes [color=#43A047]1[/color], remove all [color=orange]rage[/color]."


func get_texture() -> Texture2D:
	return load("res://content/cards/brute_cards/rage_effect/rage_icon.tres")

func on_apply(_creature:AbstractCreature, _instance:ActiveStatusEffect) -> void:
	if _creature is PlayerEntity:
		if _creature.offensive_trait.weight_value > 1:
			return
	_creature.effects.active_effects.erase(_instance)
	_creature.stat_display.status_effect_container.icons[_instance].queue_free()
	_creature.stat_display.status_effect_container.icons.erase(_instance)

func modify_attack_damage(damage:int, _instance:ActiveStatusEffect) -> int:
	return damage + (_instance.stack * 2)
