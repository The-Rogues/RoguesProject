extends Node
class_name Trait

signal updated_trait_weight(current:int)
signal updated_trait(current:PersonalityData)

@export var data:PersonalityTrait

@export_range(1, 10) var weight_value:int = 1
@export_range(1, 10) var base_weight_value:int = 2


func initialize(personality_trait:PersonalityTrait, starting_weight:int):
	data = personality_trait
	weight_value = starting_weight
	base_weight_value = starting_weight


func set_trait(personality_trait:PersonalityTrait):
	data = personality_trait
	updated_trait.emit(personality_trait)


func set_weight(weight:int):
	weight_value = clampi(weight, 1, 10)
	updated_trait_weight.emit(weight_value)
