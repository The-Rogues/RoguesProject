extends MiniEventResult
class_name GiveItemEvent

@export var item:ItemData


func resolve():
	var run = GlobalSessionManager.run_progress
	
	if run:
		run.player_data.add_item(item)


func get_result_text() -> String:
	if item:
		return "You received a %s." % item.name
	return "Nothing happened."
