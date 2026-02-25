extends Resource
class_name CardLootPool

enum Rarity {COMMON, UNCOMMON, RARE, SUPER_RARE}
@export var shared_cards:Array[CardData]

func get_cards(personality:PersonalityData):
	var personality_trait:PersonalityTrait = personality.get_priority_trait()
	pass
