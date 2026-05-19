extends StatusEffectBehaviour
class_name DazedEffect

var slf_stack: int = 0

func on_stack(
	instance:ActiveStatusEffect, 
	_other:ActiveStatusEffect = null,
	_affected: AbstractCreature = null
) -> void:
	if _other.stack < 0:
		instance.stack = -2
		slf_stack = -2
	else:
		instance.stack += _other.stack
		slf_stack += _other.stack
	instance.duration = -1
	if instance.stack == 0:
		_affected.effects.active_effects.erase(instance)
		_affected.stat_display.status_effect_container.icons[instance].queue_free()
		_affected.stat_display.status_effect_container.icons.erase(instance)

func get_status_name() -> String:
	return "Dazed"

func get_description(_instance:ActiveStatusEffect) -> String:
	return "When [color=orange]dazed[/color] is positive, the enemy cannot attack."

func get_texture() -> Texture2D:
	return load("res://content/monsters/gatling_worm/dazed_status/dazed_icon.tres")

func on_apply(_creature:AbstractCreature, _instance:ActiveStatusEffect) -> void:
	slf_stack = _instance.stack

func can_execute_action(
	_action:Action, 
	_instance:ActiveStatusEffect = null
) -> bool:
	if _action is not AttackAction && _action is not ProjectileAttackAction:
		return true
	
	if slf_stack > 0:
		return false
	
	return true
