extends Resource
class_name PersonalityTrait
## Resource that defines traits for [Personality] class, it's behavioural
## properties, and display information
##
## Intended to be used as a creatable asset in the file system that is
## assigned to the personality trait member values of [Personality]


enum NatureCatagory {
	OFFENSIVE_NATURE,
	DEFENSIVE_NATURE,
	STRATEGIC_NATURE,
}
# TODO: Add target preferences for enemies who are dealing high damage
# and enemies who are providing the most support
enum TargetingBiasType {
	NONE, 
	HEALTHIEST, # Highest HP
	UNHEALTHIEST, # Lowest HP
}

enum MovingBiasType {
	NONE,
	COVER,
	WEAPON,
	TREASURE,
}

## Groups trait into a category of natures.
## OFFENSIVE_NATURE: Influences capacity and attitude towards violence.
## DEFENSIVE_NATURE: Influences capacity and attitude towards self-preservation.
## STRATEGIC_NATURE: Supplimentary motivation for other natures.
@export var nature_category:NatureCatagory
## Sets the priority for what enemies to target.
## NONE: Targeting is not influenced by the this trait. If all Traits are NONE,
## defualt will trarget an enemy randomly.
## HEALTHIEST: Among a group of enemis, targets the one with current highest HP.
## UNHEALTHIEST: Among a group of enemis, targets the one with current lowest HP.
@export var targeting_bias:TargetingBiasType
## Sets the priority for what direction to move towards given an object of 
## of interest is in that direction.
## NONE: Movement direction is not influenced by the this trait. If all traits. 
## in a [Personality] are NONE, move direction will be random.
## OPEN: Moves towards closest position with no objects infront of it.
## COVER: Moves towards closest position with a protective objects infront of it.
## WEAPON: Moves towards closest position with a object that deals or increases
## damage.
## TREASURE: Moves towards closest positon with an object that gives a reward when
## interacted with.
@export var moving_bias:MovingBiasType
## Displayed when trait is made visible.
@export var trait_icon:Texture2D
## Unique identifier for this type of trait
@export var id:String
## Diaplayed when trait is made visible.
@export var name:String
## Displayed when trait is made visible and mouse is hovered over trait icon.
@export_multiline var description:String


func get_healthiest_target(entities:Array[BattleEntity]):
	var target:BattleEntity = entities[0]
	for canidate in entities:
		if canidate._health.current_health > target._health.current_health:
			target = canidate
	return target


func get_unhealthiest_target(entities:Array[BattleEntity]):
	var target:BattleEntity = entities[0]
	for canidate in entities:
		if canidate._health.current_health < target._health.current_health:
			target = canidate
	return target


func get_priority_target(entities:Array[BattleEntity]):
	match targeting_bias:
		TargetingBiasType.HEALTHIEST:
			return get_healthiest_target(entities)
		TargetingBiasType.UNHEALTHIEST:
			return get_unhealthiest_target(entities)
		_:
			return entities.pick_random()

func get_prioriry_direction(battle_field:BattleField):
	if moving_bias == MovingBiasType.NONE:
		var rand = randf()
		print("no bias")
		if rand < 0.5:
			return 1
		else:
			return -1
	
	var dir:int = battle_field.get_nearest_object_direction(moving_bias)
	return dir
