extends MiniEventResult
class_name RemoveItemEventResult


@export var item:ItemData


func resolve():
	var run = GlobalSessionManager.run_progress
	if run:
		run.player_data.remove_item(item)


func get_result_text() -> String:
	return item.name + " was removed from your inventory."
