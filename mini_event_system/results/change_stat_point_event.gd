extends MiniEventResult
class_name ChangeStatPointEvent

enum StatCategory {OFFENSIVE, DEFENSIVE, STRATEGIC}

@export var category:StatCategory
@export var amount:int = 1
var category_name:String

func resolve():
	var run = GlobalSessionManager.run_progress
	var _trait:PersonalityTrait = null
	
	if run:
		if category == StatCategory.OFFENSIVE:
			run.player_data.personality.set_trait_weight("OFFENSIVE",
					run.player_data.personality.offensive_weight + amount)
			category_name = "Offense"
		elif category == StatCategory.DEFENSIVE:
			run.player_data.personality.set_trait_weight("DEFENSIVE",
					run.player_data.personality.defensive_weight + amount)
			category_name = "Defense"
		elif category == StatCategory.STRATEGIC:
			run.player_data.personality.set_trait_weight("STRATEGIC",
					run.player_data.personality.strategic_weight + amount)
			category_name = "Strategy"


func get_result_text() -> String:
	var operation:String = ""
	
	if amount > 0:
		operation = " increased " + category_name + " by " + str(amount) + "."
	else:
		operation = " decreased " + category_name + " by " + str(amount) + "."
	
	return category_name + operation
