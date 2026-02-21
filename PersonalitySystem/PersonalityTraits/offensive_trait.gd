extends PersonalityTrait
class_name OffensiveTrait
## Resource that defines traits for [Personality] class, it's behavioural
## properties, and display information
##
## Intended to be used as a creatable asset in the file system that is
## assigned to the personality trait member values of [Personality]


## Sets the priority for what enemies to target.
## NONE: Targeting is not influenced by the this trait. If all Traits are NONE,
## defualt will trarget an enemy randomly.
## HEALTHIEST: Among a group of enemis, targets the one with current highest HP.
## UNHEALTHIEST: Among a group of enemis, targets the one with current lowest HP.

# TODO: Add target preferences for enemies who are dealing high damage
# and enemies who are providing the most support
enum TargetingBiasType {
	NONE, 
	HEALTHIEST, # Highest HP
	UNHEALTHIEST, # Lowest HP
}

@export var targeting_bias:TargetingBiasType


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
