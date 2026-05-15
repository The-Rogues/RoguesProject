extends MiniEventResult
class_name RemoveCardByNameResult

@export var card_name: String

func resolve():
	for i in range(GlobalSessionManager.run_progress.player_data.cards.size() - 1, -1, -1):
		if GlobalSessionManager.run_progress.player_data.cards[i].name == card_name:
			GlobalSessionManager.run_progress.player_data.cards.remove_at(i)
