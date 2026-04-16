extends BattleRewardData
class_name GoldRewardData

@export var amount:int
var final_amount:int = -1

const RANDOM_GOLD_AMOUNT = 7


func get_reward() -> void:
	var run = GlobalSessionManager.run_progress
	
	_ensure_final_amount()
	
	if run:
		run.player_data.set_gold(
			run.player_data.gold + final_amount)


func _ensure_final_amount():
	if final_amount == -1:
		final_amount = amount + randi_range(0, RANDOM_GOLD_AMOUNT)


func get_reward_name() -> String:
	_ensure_final_amount()
	return "Found Gold (" + str(final_amount) + ")."
