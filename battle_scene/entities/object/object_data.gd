extends AbstractEntityData
class_name ObjectData

enum MoveTargetingCategory {
	COVER,
	WEAPON,
	TREASURE, 
	THREAT,
	DECOY
}
enum InteractionOption {NONE, ON_HIT, BUTTON, BUTTON_WITH_KEY, ON_ENTERED_TURN}

@export var targeting_categories: Array[MoveTargetingCategory]
@export var interaction:InteractionOption
@export var interaction_actions:Array[Action]
@export_range(-1, 10) var turn_interaction_counter:int = -1
@export var is_enemy:bool = false
# Behaviour scripts


func can_open_chest():
	var run = GlobalSessionManager.run_progress
	
	if run:
		var key = run.player_data.get_key_item("open_chest")
		if key:
			return true
	return false
