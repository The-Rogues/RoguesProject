extends MiniEventResult
class_name RemoveAllGoldResult

func resolve():
	GlobalSessionManager.run_progress.player_data.set_gold(0)
