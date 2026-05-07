extends StatusEffectBehaviour
class_name ArmorEffect


func on_stack(
	instance:ActiveStatusEffect, 
	_other:ActiveStatusEffect = null,
	_affected: AbstractCreature = null
) -> void:
	instance.stack += _other.stack
	instance.duration = -1
	if _affected is PlayerEntity:
		_affected.block.add_block(_other.stack)


func get_status_name() -> String:
	return "Armor"


func get_description(_instance:ActiveStatusEffect) -> String:
	return "On apply, gain block equal to applied armor. On turn entered, gain " + str(_instance.stack) + " block. Decreases by 2 every turn."

func get_texture() -> Texture2D:
	return load("res://content/cards/stoic_cards/suit_up/armor/armor_icon.tres")

func on_apply(_creature:AbstractCreature, _instance:ActiveStatusEffect) -> void:
	if _creature is PlayerEntity:
		_creature.block.add_block(_instance.stack)

func on_turn_entered(
	_creature:AbstractCreature = null,
	_instance:ActiveStatusEffect = null
) -> void:
	_instance.stack -= 2
	_creature.block.add_block(_instance.stack)
	if _instance.stack <= 0:
		_creature.effects.active_effects.erase(_instance)
		_creature.stat_display.status_effect_container.icons[_instance].queue_free()
		_creature.stat_display.status_effect_container.icons.erase(_instance)
		effect_ended.emit()
