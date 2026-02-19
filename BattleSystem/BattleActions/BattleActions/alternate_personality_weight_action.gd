extends BattleAction
class_name AlternatePersonalityWeightAction

enum PersonalityCategory {OFFENSIVE, DEFENSIVE, STRATEGIC}
enum ComparisonType {MORE, LESS}
@export var category:PersonalityCategory
@export var comparison:ComparisonType
@export_range(1, 10) var weight_threshold:int = 5
@export var default_action:BattleAction
@export var alternate_action:BattleAction

func _execute(battle_instance:BattleManager, action_user:BattleEntity):
	var personality_weight:int = 0
	
	if category == PersonalityCategory.OFFENSIVE:
		personality_weight = battle_instance.character_personality.offensive_weight
	elif category == PersonalityCategory.DEFENSIVE:
		personality_weight = battle_instance.character_personality.defensive_weight
	elif category == PersonalityCategory.STRATEGIC:
		personality_weight = battle_instance.character_personality.strategic_weight
	
	if comparison == ComparisonType.MORE:
		if personality_weight > weight_threshold:
			battle_instance.action_queue.enqueue(
				alternate_action,
				battle_instance,
				action_user
			)
		else:
			if not alternate_action:
				return
			
			battle_instance.action_queue.enqueue(
				default_action,
				battle_instance,
				action_user
			)
	elif comparison == ComparisonType.LESS:
		if personality_weight >= weight_threshold:
			battle_instance.action_queue.enqueue(
				default_action,
				battle_instance,
				action_user
			)
		else:
			if not alternate_action:
				return
			
			battle_instance.action_queue.enqueue(
				alternate_action,
				battle_instance,
				action_user
			)
