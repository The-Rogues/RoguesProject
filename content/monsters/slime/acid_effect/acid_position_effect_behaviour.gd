extends PositionEffectBehaviour
class_name AcidPositionEffectBehaviour

var existence_turns: int = 0

func get_effect_name() -> String:
	return "Acid"

func get_description(_instance:PositionEffect) -> String:
	return "Player takes 6 damage if they are here when the turn ends. Removed on turn end."

func on_entered(player:PlayerEntity, _instance:PositionEffect) -> void:
	pass

func on_turn_ended(_player:PlayerEntity, _instance:PositionEffect) -> void:
	if _player:
		_player.take_damage(6)
	_instance.end_effect()
