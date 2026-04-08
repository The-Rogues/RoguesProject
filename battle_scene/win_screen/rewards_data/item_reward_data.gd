extends BattleRewardData
class_name ItemRewardData

@export var item:ItemData

func get_reward() -> void:
	GlobalSessionManager.add_held_item(item)
