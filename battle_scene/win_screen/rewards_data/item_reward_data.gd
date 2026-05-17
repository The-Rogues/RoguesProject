extends BattleRewardData
class_name ItemRewardData

@export var item:ItemData
@export_range(0.01, 1.0) var weight:float = 0.5

func get_reward() -> bool:
	if GlobalSessionManager.run_progress.player_data.add_item(item):
		return true
	else:
		return false


func get_reward_name() -> String:
	return item.name


func get_reward_texture() -> Texture2D:
	return item.display_texture
