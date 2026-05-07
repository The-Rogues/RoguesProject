extends StatusEffectBehaviour
class_name StuckStatusEffect

func on_stack(
	instance:ActiveStatusEffect, 
	_other:ActiveStatusEffect = null,
	_affected: AbstractCreature = null
) -> void:
	pass


func get_status_name() -> String:
	return "Stuck"


func get_description(_instance:ActiveStatusEffect) -> String:
	return "Unable to move."


func get_texture() -> Texture2D:
	return load("res://battle_scene/entities/status_effects/common/stuck_icon.tres")


func on_apply(_creature:AbstractCreature, _instance:ActiveStatusEffect) -> void:
	if _creature is PlayerEntity:
		_creature.movement_controller.can_move = false


func on_remove(_creature:AbstractCreature, _instance:ActiveStatusEffect) -> void:
	if _creature is PlayerEntity:
		_creature.movement_controller.can_move = true
