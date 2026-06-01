extends StatusEffectBehaviour
class_name ThornsStatusEffectBehaviour

var permanant_stack: int = 0

func on_stack(
	instance:ActiveStatusEffect, 
	_other:ActiveStatusEffect = null,
	_affected: AbstractCreature = null
) -> void:
	if _other.duration == -1:
		permanant_stack += _other.stack
		instance.duration = -1
	elif instance.duration != -1:
		instance.duration = 1
	instance.stack += _other.stack


func get_status_name() -> String:
	return "Thorns"


func get_description(_instance:ActiveStatusEffect) -> String:
	return "On Attacked: Attacker takes damage equal to [color=orange]thorns[/color]. [color=orange]Thorns[/color] disapears on turn start."


func get_texture() -> Texture2D:
	return load("res://battle_scene/entities/status_effects/common/thorns_icon.tres")

func on_apply(_creature:AbstractCreature, _instance:ActiveStatusEffect) -> void:
	if _instance.duration == -1:
		permanant_stack = _instance.stack
	else:
		_instance.duration = 1

func on_attacked(_attacker, _instance:ActiveStatusEffect):
	if _attacker is AbstractEntity:
		_attacker.take_damage(_instance.stack, null)

func on_turn(
	_creature:AbstractCreature = null,
	_instance:ActiveStatusEffect = null
) -> void:
	if _instance.duration == -1:
		_instance.stack = permanant_stack
