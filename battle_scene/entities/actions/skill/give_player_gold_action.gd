extends Action
class_name GivePlayerGoldAction

@export var amount:int


func execute(_context:BattleContext = null, _user:AbstractEntity = null):
	var run = GlobalSessionManager.run_progress
	
	if run:
		run.player_data.set_gold(run.player_data.gold + amount)
