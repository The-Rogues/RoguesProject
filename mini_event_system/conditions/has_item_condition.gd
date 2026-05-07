extends MiniEventCondition
class_name HasItemCondition

@export var item:ItemData


func is_met() -> bool:
	var run = GlobalSessionManager.run_progress
	
	if run:
		return run.player_data.items.has(item)
	
	return false
