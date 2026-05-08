extends MiniEventCondition
class_name HasGoldCondition

@export var required_gold:int

func is_met() -> bool:
	var run = GlobalSessionManager.run_progress
	
	if run:
		return run.player_data.gold >= required_gold
	
	return false
