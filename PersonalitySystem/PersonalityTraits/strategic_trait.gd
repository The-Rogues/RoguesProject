extends PersonalityTrait
class_name StrategicTrait
## Resource that defines traits for [Personality] class, it's behavioural
## properties, and display information
##
## Intended to be used as a creatable asset in the file system that is
## assigned to the personality trait member values of [Personality]

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
enum MovingBiasType {
	NONE,
	COVER,
	WEAPON,
	TREASURE,
}

@export var moving_bias:MovingBiasType

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
