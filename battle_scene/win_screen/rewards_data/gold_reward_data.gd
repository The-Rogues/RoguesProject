extends BattleRewardData
class_name GoldRewardData

@export var amount:int


func get_reward() -> void:
	var run = GlobalSessionManager.run_progress
	
	if run:
		run.player_data.set_gold(
			run.player_data.gold + amount)
