extends MiniEventResult
class_name GiveGoldEventResult

@export var gold:int


func resolve():
	var run = GlobalSessionManager.run_progress
	
	if run:
		run.player_data.set_gold(
			run.player_data.gold + gold
		)


func get_result_text() -> String:
	if gold > 0:
		return "You received %s Gold." % gold
	elif gold < 0:
		return "You lost %s Gold." % gold
	return "Nothing happened."
