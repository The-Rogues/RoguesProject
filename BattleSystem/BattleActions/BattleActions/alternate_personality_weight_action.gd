extends BattleAction
class_name AlternatePersonalityWeightAction

enum PersonalityCategory {AGGRESSION, SURVIVAL, DRIVE}
enum ComparisonType {MORE, LESS}
@export var category:PersonalityCategory
@export var comparison:ComparisonType
@export_range(1, 10) var weight_threshold:int = 5
@export var default_action:BattleAction
@export var alternate_action:BattleAction

func _execute(battle_instance:BattleManager, action_user:BattleEntity):
	var character_data := battle_instance.player_entity.entity_data as CharacterData
	var personality_trait:TraitData = null
	
	if category == PersonalityCategory.AGGRESSION:
		personality_trait = character_data.offensive_trait
	elif category == PersonalityCategory.SURVIVAL:
		personality_trait = character_data.defensive_trait
	elif category == PersonalityCategory.DRIVE:
		personality_trait = character_data.strategic_trait
	
	print(personality_trait.weight)
	print(personality_trait.weight > weight_threshold)
	print(weight_threshold)
	
	if comparison == ComparisonType.MORE:
		if personality_trait.weight > weight_threshold:
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
		if personality_trait.weight >= weight_threshold:
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
