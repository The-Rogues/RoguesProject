extends PositionEffectBehaviour
class_name StatusPositionEffect

@export var status:StatusEffectConfig


func get_effect_name() -> String:
	return status.behaviour.get_status_name() + " Position"


func get_description(_instance:PositionEffect) -> String:
	return "On Entered: Applies [color=#43A047]" + str(_instance.stack) + "[/color] [color=orange]" + status.behaviour.get_status_name() + "[/color]." 


func on_entered(player:PlayerEntity, _instance:PositionEffect) -> void:
	player.apply_status_effect(status, true)
