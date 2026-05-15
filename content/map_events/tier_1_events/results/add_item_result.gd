extends MiniEventResult
class_name AddItemResult

@export var item: ItemData

func resolve():
	GlobalSessionManager.run_progress.player_data.add_item(item)
