extends MiniEventResult
class_name ReplaceCardByNameResult

@export var card_name: String
@export var new_card: CardData

func resolve():
	for i in range(GlobalSessionManager.run_progress.player_data.cards.size() - 1, -1, -1):
		if GlobalSessionManager.run_progress.player_data.cards[i].name == card_name:
			GlobalSessionManager.run_progress.player_data.cards.remove_at(i)
			GlobalSessionManager.run_progress.player_data.cards.append(new_card)
	GlobalSessionManager.run_progress.player_data.cards_updated.emit(
		GlobalSessionManager.run_progress.player_data.cards
	)
