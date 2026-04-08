extends RefCounted
class_name PersonalityData
## Resource that stores personality traits and functions for resolving targets
## and movement direction.
##
## Intended to be used as a creatable asset by a character creator script
## that stores it's instance in a persistent manner.

signal updated_offensive_trait(_trait:PersonalityTrait, weight:int)
signal updated_defensive_trait(_trait:PersonalityTrait, weight:int)
signal updated_strategic_trait(_trait:PersonalityTrait, weight:int)
signal updated_priority_trait(_trait:PersonalityTrait)
signal updated(personality:PersonalityData)

## Influences capacity and attitude towards violence.
var offensive_trait:PersonalityTrait
## Controls how much the offensive trait is priotized over other traits.
var offensive_weight:int
## Influences capacity and attitude towards self-preservation.
var defensive_trait:PersonalityTrait
## Controls how much the defensive trait is priotized over other traits.
var defensive_weight:int
## Supplimentary motivation for other natures.
var strategic_trait:PersonalityTrait
## Controls how much the strategic trait is priotized over other traits.
var strategic_weight:int

var priority_trait:PersonalityTrait = null

const MINIMUM_WEIGHT = 1
const  MAXIMUM_WEIGHT = 10

func _init(
		_offensive_trait:PersonalityTrait,
		_defensive_trait:PersonalityTrait,
		_strategic_trait:PersonalityTrait,
		_priority_trait:String
) -> void:
	offensive_trait = _offensive_trait
	defensive_trait = _defensive_trait
	strategic_trait = _strategic_trait
	
	offensive_weight = 1
	defensive_weight = 1
	strategic_weight = 1
	
	var trait_category = _priority_trait.to_upper()
	
	if trait_category == "OFFENSIVE":
		priority_trait = offensive_trait
		offensive_weight = 4
	elif trait_category == "DEFENSIVE":
		priority_trait = defensive_trait
		defensive_weight = 4
	elif trait_category == "STRATEGIC":
		priority_trait = strategic_trait
		strategic_weight = 4


func has_trait(_trait:String) -> bool:
	var trait_name:String = _trait.to_upper()
	
	if offensive_trait.name == trait_name:
		return true
	if defensive_trait.name == trait_name:
		return true
	if strategic_trait.name == trait_name:
		return true
	return false


func set_trait(trait_category:String, _trait:PersonalityTrait) -> void:
	match trait_category.to_upper():
		"OFFENSIVE":
			if offensive_trait !=  _trait:
				offensive_trait = _trait
				updated_offensive_trait.emit(offensive_trait, offensive_weight)
				updated.emit(self)
		"DEFENSIVE":
			if defensive_trait != _trait:
				defensive_trait = _trait
				updated_defensive_trait.emit(defensive_trait, defensive_weight)
				updated.emit(self)
		"STRATEGIC":
			if strategic_trait != _trait:
				strategic_trait = _trait
				updated_strategic_trait.emit(strategic_trait, strategic_weight)
				updated.emit(self)
		_:
			return
	
	update_priority_trait()


func set_trait_weight(trait_category:String, _weight:int) -> void:
	match trait_category.to_upper():
		"OFFENSIVE":
			offensive_weight = _weight
			offensive_weight = clampi(
					offensive_weight, 
					MINIMUM_WEIGHT, 
					MINIMUM_WEIGHT)
			updated_offensive_trait.emit(offensive_trait, offensive_weight)
			updated.emit(self)
		"DEFENSIVE":
			defensive_weight = _weight
			defensive_weight = clampi(defensive_weight, 
					MINIMUM_WEIGHT, 
					MINIMUM_WEIGHT)
			updated_defensive_trait.emit(defensive_trait, defensive_weight)
			updated.emit(self)
		"STRATEGIC":
			strategic_weight = _weight
			strategic_weight = clampi(strategic_weight, 
					MINIMUM_WEIGHT, 
					MINIMUM_WEIGHT)
			updated_strategic_trait.emit(strategic_trait, strategic_weight)
			updated.emit(self)
		_:
			pass
	
	update_priority_trait()


func update_priority_trait() -> void:
	var _priority_trait:PersonalityTrait = strategic_trait
	if defensive_weight >= strategic_weight:
		priority_trait = defensive_trait
	if offensive_weight >= defensive_weight:
		priority_trait = offensive_trait
	
	if priority_trait != _priority_trait:
		priority_trait = _priority_trait
		updated_priority_trait.emit(priority_trait)


# TODO: Move to dedicated DeckBuilder class
func get_starting_deck() -> Array[CardData]:
	var deck:Array[CardData] = []
	deck.append_array(offensive_trait.starter_cards)
	deck.append_array(defensive_trait.starter_cards)
	deck.append_array(strategic_trait.starter_cards)
	
	return deck
