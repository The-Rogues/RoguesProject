extends BattleRewardData
class_name GoldRewardData

@export var amount:int
var final_amount:int = -1

const RANDOM_GOLD_AMOUNT = 7


func get_reward() -> bool:
	var run = GlobalSessionManager.run_progress
	
	_ensure_final_amount()
	
	if run:
		run.player_data.set_gold(
			run.player_data.gold + final_amount)
	return true


func _ensure_final_amount():
	if final_amount == -1:
		final_amount = amount + randi_range(0, RANDOM_GOLD_AMOUNT)


func get_reward_name() -> String:
	_ensure_final_amount()
	if name == "":
		return "Found Gold (" + str(final_amount) + ")"
	else:
		return name + " (" + str(final_amount) + ")"
