extends PositionEffectBehaviour
class_name IceSpikesPositionEffectBehaviour

var curr_position: BattlePosition = null

func get_effect_name() -> String:
	return "Ice Spikes"


func get_description(_instance:PositionEffect) -> String:
	return "The player takes " + str(_instance.stack) + " damage when entering or exiting this position."


func on_entered(player:PlayerEntity, _instance:PositionEffect) -> void:
	player.take_damage(_instance.stack)

func on_exited(player:PlayerEntity, _instance:PositionEffect) -> void:
	player.take_damage(_instance.stack)
