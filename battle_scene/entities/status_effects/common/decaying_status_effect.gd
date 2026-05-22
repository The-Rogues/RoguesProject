extends StatusEffectBehaviour
class_name DecayingStatusEffect

var turns_passed: int = 0

func on_stack(
	instance:ActiveStatusEffect, 
	_other:ActiveStatusEffect = null,
	_affected: AbstractCreature = null
) -> void:
	instance.duration += 1


func get_status_name() -> String:
	return "Decaying"


func get_description(_instance:ActiveStatusEffect) -> String:
	return "Will die in " + str(_instance.duration) + " turns."


func get_texture() -> Texture2D:
	return load("res://battle_scene/entities/status_effects/common/decaying_icon.tres")


func on_turn(
	_creature:AbstractCreature = null,
	_instance:ActiveStatusEffect = null
) -> void:
	if _instance.duration == 1:
		_creature.health.kill()

#func on_remove(_creature:AbstractCreature, _instance:ActiveStatusEffect) -> void:
#	_creature.health.kill()
