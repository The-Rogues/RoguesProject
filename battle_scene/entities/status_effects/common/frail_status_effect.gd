extends StatusEffectBehaviour
class_name FrailEEffect


func on_stack(
	instance:ActiveStatusEffect, 
	_other:ActiveStatusEffect = null,
	_affected: AbstractCreature = null
) -> void:
	instance.duration += _other.duration


func get_status_name() -> String:
	return "Frail"


func get_description(_instance:ActiveStatusEffect) -> String:
	return "Damage received from attacks is increased by [color=#43A047]50[/color] percent. Decreaeses every turn."


func get_texture() -> Texture2D:
	return load("res://battle_scene/entities/status_effects/common/frail_icon.tres")


func modify_incoming_damage(damage:int, _instance:ActiveStatusEffect) -> int:
	return roundi(damage * 1.5)
