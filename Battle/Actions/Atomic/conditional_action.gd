extends TargetedBattleAction
class_name ConditionalAction
## Serves as a BattleAction Router rather then effecting anything in a battle
## directly.
##
## Different options are available for comparison operations. Alternative
## actions are queable for if the specified condition is met or not met.


enum Condition {
	HAS_TRAIT,
	PERSONALITY_WEIGHT_COMPARE,
	RANDOM_CHANCE,
	TARGET_HEALTH_COMPARE,
	USER_HEALTH_COMPARE,
	OBJECT_EXISTS,
	OBJECT_AT_POSITION,
}

enum PersonalityCategory { OFFENSIVE, DEFENSIVE, STRATEGIC }
enum ComparisonType { GREATER, LESS }

# -----------------------------
# Shared outputs
# -----------------------------
@export var true_action:BattleAction
@export var false_action:BattleAction

# -----------------------------
# Condition selector
# -----------------------------
@export var condition:Condition

@export_group("Conditional Options")
# -----------------------------
# HAS_TRAIT
# -----------------------------
@export var personality_trait:PersonalityTrait

# -----------------------------
# PERSONALITY_WEIGHT_COMPARE
# -----------------------------
@export var category:PersonalityCategory
@export var comparison:ComparisonType
@export_range(1, 10) var weight_threshold:int = 5

# -----------------------------
# OBJECT_EXISTS & OBJECT_AT_POSITION
# -----------------------------
@export_group("Object Condition Options")
@export var object_id:String
@export var move_to_object:bool = false

# -----------------------------
# RANDOM_CHANCE
# -----------------------------
@export_range(0.0, 1.0) var random_chance:float = 0.5

# -----------------------------
# HEALTH COMPARES
# -----------------------------
@export_range(0.0, 1.0) var health_ratio_threshold:float = 0.5

func _execute(battle_instance:BattleManager, _action_user:BattleEntity = null):
	super(battle_instance, _action_user)
	var result:bool = false
	
	match condition:
		Condition.HAS_TRAIT:
			result = battle_instance.character_personality.has_trait(
				personality_trait.id
			)
		Condition.PERSONALITY_WEIGHT_COMPARE:
			result = _personality_weight_compare(battle_instance)
		Condition.RANDOM_CHANCE:
			result = randf() <= random_chance
		Condition.TARGET_HEALTH_COMPARE:
			if targets.size() == 1:
				result = targets[0].health_ratio <= health_ratio_threshold
			else:
				result = false
		Condition.USER_HEALTH_COMPARE:
			result = _action_user.health_ratio <= health_ratio_threshold
		Condition.OBJECT_EXISTS:
			var pos:BattlePosition = battle_instance.battle_field.find_object(object_id)
			
			if pos and move_to_object:
				battle_instance.battle_field.move_entity(pos)
				await battle_instance.battle_field.entity_arrived
			
			result = pos != null
		Condition.OBJECT_AT_POSITION:
			var object:ObjectEntity = battle_instance.battle_field.get_object()
			result = object != null and object.data.id == object_id
			
			# Enqueue true branch if condition is met, otherwise enqueue false branch
			var action:BattleAction = true_action if result else false_action
			if action:
				battle_instance.action_queue.enqueue(
					action,
					battle_instance,
					_action_user
				)


func _personality_weight_compare(battle_instance:BattleManager) -> bool:
	var personality:PersonalityData = battle_instance.character_personality
	var value:int = 0
	
	match category:
		PersonalityCategory.OFFENSIVE:
			value = personality.offensive_weight
		PersonalityCategory.DEFENSIVE:
			value = personality.defensive_weight
		PersonalityCategory.STRATEGIC:
			value = personality.strategic_weight
	
	match comparison:
		ComparisonType.GREATER:
			return value > weight_threshold
		ComparisonType.LESS:
			return value < weight_threshold
	
	return false
