extends PositionEffectBehaviour
class_name GemPositionEffectBehaviour

var gem_effect: StatusEffectConfig = preload("res://content/cards/greedy_cards/unearth/gem_position/gem_status_config.tres")

func get_effect_name() -> String:
	return "Gem Position"

func get_description(_instance:PositionEffect) -> String:
	return "Player gains a gem when entered."

func on_entered(player:PlayerEntity, _instance:PositionEffect) -> void:
	player.effects.add_effect(
		gem_effect.behaviour,
		gem_effect.duration,
		gem_effect.stack
	)
