extends PositionEffectBehaviour
class_name AcidPositionEffectBehaviour

func get_effect_name() -> String:
	return "Acid"


func get_description(_instance:PositionEffect) -> String:
	return "Player takes " + str(_instance.stack) + " Damage when entered"


func on_entered(player:PlayerEntity, _instance:PositionEffect) -> void:
	player.take_damage(_instance.stack)
	_instance.end_effect()
