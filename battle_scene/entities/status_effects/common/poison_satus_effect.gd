extends StatusEffectBehaviour
class_name PoisonStatusEffect


func on_stack(
	instance:ActiveStatusEffect, 
	_other:ActiveStatusEffect = null,
	_affected: AbstractCreature = null
) -> void:
	instance.duration += 1
	instance.stack += 1


func get_status_name() -> String:
	return "Poisoned"


func get_description(_instance:ActiveStatusEffect) -> String:
	return "Take " + str(_instance.stack) + " damage each turn."


func get_texture() -> Texture2D:
	return load("res://battle_scene/entities/status_effects/common/poisoned_icon.tres")


func on_turn_entered(
	_creature:AbstractCreature = null,
	_instance:ActiveStatusEffect = null
) -> void:
	_creature.take_damage(_instance.stack)
