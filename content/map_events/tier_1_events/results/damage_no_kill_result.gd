extends MiniEventResult
class_name DamageNoKillResult

@export var damage_amount: int

func resolve():
	var max_health: int = GlobalSessionManager.run_progress.player_data.max_health
	var curr_health: int = GlobalSessionManager.run_progress.player_data.current_health
	curr_health -= damage_amount
	if curr_health < 1:
		curr_health = 1
	GlobalSessionManager.run_progress.player_data.set_health(curr_health, max_health)
