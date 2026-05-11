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
	return "On Hit: Attacker gains infection equal to stack. On Turn Entered: Take damage equal to stack (" + str(_instance.stack) + ")"

func get_texture() -> Texture2D:
	return load("res://content/monsters/the_infected/infection.tres")

func on_turn_entered(
	_creature:AbstractCreature = null,
	_instance:ActiveStatusEffect = null
) -> void:
	_creature.take_damage(_instance.stack)
	_instance.stack -= 1
	if _instance.stack <= 0:
		_creature.effects.active_effects.erase(_instance)
		_creature.stat_display.status_effect_container.icons[_instance].queue_free()
		_creature.stat_display.status_effect_container.icons.erase(_instance)
		effect_ended.emit()

func on_attacked(_attacker:AbstractEntity, _instance:ActiveStatusEffect):
	if _attacker is AbstractCreature:
		var new_infection: StatusEffectConfig = StatusEffectConfig.new()
		new_infection.behaviour = self
		new_infection.duration = -1
		new_infection.stack = _instance.stack
		_attacker.apply_status_effect(new_infection)
