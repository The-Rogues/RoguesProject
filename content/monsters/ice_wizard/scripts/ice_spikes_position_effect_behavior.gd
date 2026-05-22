extends PositionEffectBehaviour
class_name IceSpikesPositionEffectBehaviour

var curr_position: BattlePosition = null

func get_effect_name() -> String:
	return "Ice Spikes"


func get_description(_instance:PositionEffect) -> String:
	return "On Exit: Gain [color=#43A047]" + str(_instance.stack) + "[/color] [color=orange]freezing[/color].\nRemoved on turn end.\n"

func on_entered(player:PlayerEntity, _instance:PositionEffect) -> void:
	pass

func on_exited(player:PlayerEntity, _instance:PositionEffect) -> void:
	var freeze_effect: StatusEffectConfig = StatusEffectConfig.new()
	freeze_effect.behaviour  = FreezingBehavior.new()
	freeze_effect.duration = -1
	freeze_effect.stack = _instance.stack
	player.apply_status_effect(freeze_effect, true)

func on_turn_ended(_player:PlayerEntity, _instance:PositionEffect) -> void:
	_instance.end_effect()
