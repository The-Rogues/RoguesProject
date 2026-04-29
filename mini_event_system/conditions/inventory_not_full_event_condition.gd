extends MiniEventCondition
class_name InventoryNotFullEventCondition

func is_met() -> bool:
	var run = GlobalSessionManager.run_progress
	
	if run:
		return !run.player_data.inventory_full()
	return false
