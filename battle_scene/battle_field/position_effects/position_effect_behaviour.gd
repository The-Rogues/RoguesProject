@abstract
extends Resource
class_name PositionEffectBehaviour

signal cleared_effect

@abstract
func get_effect_name() -> String

@abstract
func get_description(_instance:PositionEffect) -> String

@abstract
func on_entered(player:PlayerEntity, _instance:PositionEffect) -> void

func on_turn_entered(_player:PlayerEntity, _instance:PositionEffect) -> void:
	pass

func on_exited(_player:PlayerEntity, _instance:PositionEffect) -> void:
	pass


func clear_effect():
	cleared_effect.emit()
