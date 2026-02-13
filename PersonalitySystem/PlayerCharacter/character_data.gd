extends EntityData
class_name CharacterData

enum EmotionalState {
	NEUTRAL,
	FOCUSED,
	CONFIDENT,
	ANGRY,
	SAD,
	CONFUSED,
	}
# Used to store information on the player's in game character
@export var offensive_trait:TraitData
@export var defensive_trait:TraitData
@export var strategic_trait:TraitData
@export var energy:Stat = Stat.new(5, 0, 5, true)
@export var mood:EmotionalState = EmotionalState.NEUTRAL

func change_trait(target_trait:String, new_trait:TraitData):
	match target_trait:
		"OFFENSIVE":
			offensive_trait = new_trait.duplicate(true)
		"DEFENSIVE":
			defensive_trait = new_trait.duplicate(true)
		"STRATEGIC":
			strategic_trait = new_trait.duplicate(true)

func has_trait(trait_data:TraitData):
	if offensive_trait.id == trait_data.id:
		return true
	if defensive_trait.id == trait_data.id:
		return true
	if strategic_trait.id == trait_data.id:
		return true
	return false

# Constructor
func initialize(
	new_name:String,
			new_offensive_trait:TraitData,
			new_defensive_trait:TraitData,
			new_strategic_trait:TraitData,
			new_behaviours:Array[EntityBehaviour] = []) -> void:
		name = new_name
		offensive_trait = new_offensive_trait
		defensive_trait = new_defensive_trait
		strategic_trait = new_strategic_trait
		health_points = 80
		health = Stat.new(80, 0, 80, false)
		energy = Stat.new(5, 0, 5, true)
		wait_to_hide_sprite = true
		
		if !new_behaviours.is_empty():
			behaviours = new_behaviours.duplicate(true)
