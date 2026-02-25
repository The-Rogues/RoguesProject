extends TargetedBattleAction
class_name ConditionalAction

enum Condition {
	HAS_TRAIT,
	PERSONALITY_WEIGHT_COMPARE,
	RANDOM_CHANCE,
	TARGET_HEALTH_COMPARE,
	USER_HEALTH_COMPARE,
	GOLD_COMPARE,
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

# -----------------------------
# HAS_TRAIT
# -----------------------------
@export_group("Has Trait Options")
@export var personality_trait:PersonalityTrait

# -----------------------------
# PERSONALITY_WEIGHT_COMPARE
# -----------------------------
@export_group("Trait weight comparison Options")
@export var category:PersonalityCategory
@export var comparison:ComparisonType
@export_range(1, 10) var weight_threshold:int = 5

# -----------------------------
# RANDOM_CHANCE
# -----------------------------
@export_group("Random Chance options")
@export_range(0.0, 1.0) var chance:float = 0.5

# -----------------------------
# HEALTH COMPARES
# -----------------------------
@export_group("Health Compare Options")
@export_range(0.0, 1.0) var health_ratio_threshold:float = 0.5

# -----------------------------
# Gold COMPARE
# -----------------------------
@export_group("Gold Compare Options")
@export var spend_gold:bool
@export_range(1, 999) var gold_threshold:int = 1

func _execute(battle_instance:BattleManager, _action_user:BattleEntity = null):
	var targeting = _resolve_target(battle_instance, _action_user)
	var result := false
	
	match condition:
		Condition.HAS_TRAIT:
			result = battle_instance.character_personality.has_trait(
				personality_trait.id
			)
		Condition.PERSONALITY_WEIGHT_COMPARE:
			result = _personality_weight_compare(battle_instance)
		Condition.RANDOM_CHANCE:
			result = randf() <= chance
		Condition.TARGET_HEALTH_COMPARE:
			if targeting.size() == 1:
				result = targeting[0].health_ratio <= health_ratio_threshold
			else :
				result = false
		Condition.USER_HEALTH_COMPARE:
			result = _action_user.health_ratio <= health_ratio_threshold
		Condition.GOLD_COMPARE:
			result = GlobalSessionManager.run_progress.gold <= gold_threshold
			if result and spend_gold:
				GlobalSessionManager.increase_gold(-gold_threshold)
	
	# Route action
	var action := true_action if result else false_action
	if action:
		battle_instance.action_queue.enqueue(
			action,
			battle_instance,
			_action_user
		)

func _personality_weight_compare(battle_instance:BattleManager) -> bool:
	var personality := battle_instance.character_personality
	var value := 0
	
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
