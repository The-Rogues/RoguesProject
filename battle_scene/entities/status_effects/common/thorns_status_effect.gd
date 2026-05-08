extends StatusEffectBehaviour
class_name ThornsStatusEffectBehaviour


func on_stack(
	instance:ActiveStatusEffect, 
	_other:ActiveStatusEffect = null
) -> void:
	instance.stack += _other.stack
	instance.duration = 2


func get_status_name() -> String:
	return "Thorns"


func get_description(_instance:ActiveStatusEffect) -> String:
	return "Deals " + str(_instance.stack) + " damage when attacked."


func get_texture() -> Texture2D:
	return load("res://battle_scene/entities/status_effects/common/thorns_icon.tres")


func on_attacked(_attacker:AbstractEntity, _instance:ActiveStatusEffect):
	_attacker.take_damage(_instance.stack, null)

func on_turn_entered(
	_creature:AbstractCreature = null,
	_instance:ActiveStatusEffect = null
) -> void:
	if _creature is PlayerEntity:
		_creature.effects.active_effects.erase(_instance)
		_creature.stat_display.status_effect_container.icons[_instance].queue_free()
		_creature.stat_display.status_effect_container.icons.erase(_instance)
		effect_ended.emit()
	if _creature is MonsterEntity:
		_instance.duration = 1
