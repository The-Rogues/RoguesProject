extends Resource
class_name PersonalityData
## Resource that stores personality traits and functions for resolving targets
## and movement direction.
##
## Intended to be used as a creatable asset by a character creator script
## that stores it's instance in a persistent manner.


## Influences capacity and attitude towards violence.
@export var offensive_trait:PersonalityTrait
## Controls how much the offensive trait is priotized over other traits.
@export_range(1, 10) var offensive_weight:int
## Influences capacity and attitude towards self-preservation.
@export var defensive_trait:PersonalityTrait
## Controls how much the defensive trait is priotized over other traits.
@export_range(1, 10) var defensive_weight:int
## Supplimentary motivation for other natures.
@export var strategic_trait:PersonalityTrait
## Controls how much the strategic trait is priotized over other traits.
@export_range(1, 10) var strategic_weight:int


## Chooses highest priority trait by weight. If weights are the same prioritize 
## in the order: strategic < defensive < offensive
func get_priority_trait():
	var priority_trait:PersonalityTrait = strategic_trait
	if defensive_weight >= strategic_weight:
		priority_trait = defensive_trait
	if offensive_weight >= defensive_weight:
		priority_trait = offensive_trait
	
	return priority_trait


## Choosest the highest priority target given the biases of personality traits.
func get_target(entities:Array[BattleEntity]):
	var priority_trait:PersonalityTrait = get_priority_trait()
	
	return priority_trait.get_priority_target(entities)


## Uses a string trait id incase traits are grouped into sub-categories under
## an ID. Returns true if any personality trait has a matching id.
func has_trait(trait_id:String):
	if offensive_trait.id == trait_id:
		return true
	if defensive_trait.id == trait_id:
		return true
	if strategic_trait.id == trait_id:
		return true
	return false

# Constructor
func initialize(
			new_offensive_trait:PersonalityTrait,
			new_defensive_trait:PersonalityTrait,
			new_strategic_trait:PersonalityTrait,
			new_offensive_weight:int = 5,
			new_defensive_weight:int = 5,
			new_strategic_weight:int = 5,
) -> void:
		offensive_trait = new_offensive_trait
		defensive_trait = new_defensive_trait
		strategic_trait = new_strategic_trait
		
		offensive_weight = new_offensive_weight
		defensive_weight = new_defensive_weight
		strategic_weight = new_strategic_weight
