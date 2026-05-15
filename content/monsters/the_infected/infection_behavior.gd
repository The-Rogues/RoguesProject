extends StatusEffectBehaviour
class_name InfectedBehavior

func on_stack(
	instance:ActiveStatusEffect, 
	_other:ActiveStatusEffect = null,
	_affected: AbstractCreature = null
) -> void:
	instance.stack += _other.stack
	instance.duration = -1

func get_status_name() -> String:
	return "Infection"

func get_description(_instance:ActiveStatusEffect) -> String:
	return "On Hit: Attacker gains infection equal to stack. On Turn Ended: Take damage equal to stack (" + str(_instance.stack) + ")"

func get_texture() -> Texture2D:
	return load("res://content/monsters/the_infected/infection.tres")

func on_turn(
	_creature:AbstractCreature = null,
	_instance:ActiveStatusEffect = null
) -> void:
	_creature.take_damage(_instance.stack)

func on_attacked(_attacker:AbstractEntity, _instance:ActiveStatusEffect):
	if _attacker is AbstractCreature:
		var new_infection: StatusEffectConfig = StatusEffectConfig.new()
		new_infection.behaviour = self
		new_infection.duration = -1
		new_infection.stack = _instance.stack
		new_infection.turn_entered = false
		_attacker.apply_status_effect(new_infection)
