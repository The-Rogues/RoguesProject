# --mini_event_test Callback Script--
# Author: Fletcher Green

extends RefCounted

# Fabian - Changed to const for now. If there are varients of this with 
# different values, it would make a good Resource class object
const GOLD_AMOUNT = 50


# For main events, write the code to load the new screen in this function.
# For mini events, write the code to execute in this function.
func process_event() -> void:
	# Fabian - Updated to use new access pattern
	var run = GlobalSessionManager.run_progress
	if run:
		run.player_data.set_gold(run.player_data.gold + 50)
	
	#GlobalSessionManager.increase_gold(50)
