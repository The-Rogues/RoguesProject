extends StatusEffectBehaviour
class_name ArmoredEffect


func on_stack(
	instance:ActiveStatusEffect, 
	_other:ActiveStatusEffect = null,
	_affected: AbstractCreature = null
) -> void:
	instance.duration += 1


func get_status_name() -> String:
	return "Toughness"


func get_description(_instance:ActiveStatusEffect) -> String:
	return "Damage recieved from attacks is halved. Decreases every turn."


func get_texture() -> Texture2D:
	return load("res://battle_scene/entities/status_effects/common/protected_icon.tres")


func modify_incoming_damage(damage:int, _instance:ActiveStatusEffect) -> int:
	return roundi(damage * 0.5)
