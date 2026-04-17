extends PositionEffectBehaviour
class_name HealPositionEffect


func get_effect_name() -> String:
	return "Healing"


func get_description(_instance:PositionEffect) -> String:
	return "Heals " + str(_instance.stack) + " HP when stood on."


func on_entered(player:PlayerEntity, _instance:PositionEffect) -> void:
	player.health.heal(_instance.stack)
	clear_effect()
