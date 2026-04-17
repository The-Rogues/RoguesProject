extends PositionEffectBehaviour
class_name StatusPositionEffect

@export var status:StatusEffectConfig


func get_effect_name() -> String:
	return status.behaviour.get_status_name()


func get_description(_instance:PositionEffect) -> String:
	return "Applies " + status.behaviour.get_status_name() + " when stood on." 


func on_entered(player:PlayerEntity, _instance:PositionEffect) -> void:
	player.apply_status_effect(status)
