extends PositionEffectBehaviour
class_name HealPositionEffect


func on_entered(player:PlayerEntity, _instance:PositionEffect) -> void:
	player.health.heal(_instance.stack)
	clear_effect()
