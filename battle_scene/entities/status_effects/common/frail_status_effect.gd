extends StatusEffectBehaviour
class_name FrailEEffect


func on_stack(
	instance:ActiveStatusEffect, 
	_other:ActiveStatusEffect = null
) -> void:
	instance.duration += 1


func get_status_name() -> String:
	return "Frail"


func get_description(_instance:ActiveStatusEffect) -> String:
	return "Increases damage recieved from attacks by 1.5x"


func get_texture() -> Texture2D:
	return load("res://battle_scene/entities/status_effects/common/frail_icon.tres")


func modify_incoming_damage(damage:int, _instance:ActiveStatusEffect) -> int:
	return roundi(damage * 1.5)
