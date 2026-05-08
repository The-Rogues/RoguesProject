extends MiniEventResult
class_name CardRewardResult

@export var card: CardData


func resolve():
	var run = GlobalSessionManager.run_progress
	
	if run:
		run.player_data.add_card(card)


func get_result_text() -> String:
	if card:
		return "You received %s." % card.name
	return "Nothing happened."
