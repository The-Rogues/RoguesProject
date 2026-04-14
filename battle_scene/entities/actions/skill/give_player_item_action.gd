extends Action
class_name GivePlayerItemAction

@export var item_pool:Array[ItemData]

func execute(_context:BattleContext = null, _user:AbstractEntity = null):
	var run = GlobalSessionManager.run_progress
	var item = item_pool.pick_random()
	
	if run:
		run.player_data.add_item(item)
