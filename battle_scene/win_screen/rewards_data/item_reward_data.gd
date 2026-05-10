extends BattleRewardData
class_name ItemRewardData

@export var item:ItemData

func get_reward() -> bool:
	if GlobalSessionManager.run_progress.player_data.add_item(item):
		return true
	else:
		return false
