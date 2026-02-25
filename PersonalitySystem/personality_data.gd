extends Resource
class_name PersonalityData
## Resource that stores personality traits and functions for resolving targets
## and movement direction.
##
## Intended to be used as a creatable asset by a character creator script
## that stores it's instance in a persistent manner.


signal updated_traits(data:PersonalityData)
signal changed_trait(personality_trait:PersonalityTrait)

## Influences capacity and attitude towards violence.
@export var offensive_trait:OffensiveTrait
## Controls how much the offensive trait is priotized over other traits.
@export_range(1, 10) var offensive_weight:int
## Influences capacity and attitude towards self-preservation.
@export var defensive_trait:DefensiveTrait
## Controls how much the defensive trait is priotized over other traits.
@export_range(1, 10) var defensive_weight:int
## Supplimentary motivation for other natures.
@export var strategic_trait:StrategicTrait
## Controls how much the strategic trait is priotized over other traits.
@export_range(1, 10) var strategic_weight:int


func change_offensive_trait(personality_trait:PersonalityTrait, weight:int = -1):
	offensive_trait = personality_trait
	if weight > 0 and weight < 11:
		offensive_weight = weight
	updated_traits.emit(self)
	changed_trait.emit(offensive_trait)


func change_defensive_trait(personality_trait:PersonalityTrait, weight:int = -1):
	defensive_trait = personality_trait
	if weight > 0 and weight < 11:
		defensive_weight = weight
	updated_traits.emit(self)
	changed_trait.emit(defensive_trait)


func change_strategic_trait(personality_trait:PersonalityTrait, weight:int = -1):
	strategic_trait = personality_trait
	if weight > 0 and weight < 11:
		strategic_weight = weight
	updated_traits.emit(self)
	changed_trait.emit(strategic_trait)


func modify_offense(amount:int, set_exact:bool=false):
	if set_exact:
		offensive_weight = amount
	elif amount > 0:
		offensive_weight = min(offensive_weight + amount, 10)
	else:
		offensive_weight = max(offensive_weight - amount, 1)
	updated_traits.emit(self)


func modify_defense(amount:int, set_exact:bool=false):
	if set_exact:
		offensive_weight = amount
	elif amount > 0:
		defensive_weight = min(defensive_weight + amount, 10)
	else:
		defensive_weight = max(defensive_weight - amount, 1)
	updated_traits.emit(self)


func modify_strategy(amount:int, set_exact:bool=false):
	if set_exact:
		offensive_weight = amount
	elif amount > 0:
		strategic_weight = min(strategic_weight + amount, 10)
	else:
		strategic_weight = max(strategic_weight - amount, 1)
	updated_traits.emit(self)


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
			new_offensive_trait:OffensiveTrait,
			new_defensive_trait:DefensiveTrait,
			new_strategic_trait:StrategicTrait,
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


func get_target_entity(entities:Array[BattleEntity]) -> BattleEntity:
	match offensive_trait.targeting_bias:
		offensive_trait.TargetingBiasType.HEALTHIEST:
			return offensive_trait.get_healthiest_target(entities)
		offensive_trait.TargetingBiasType.UNHEALTHIEST:
			return offensive_trait.get_unhealthiest_target(entities)
		_:
			return entities.pick_random()
