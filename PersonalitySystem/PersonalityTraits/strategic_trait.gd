extends PersonalityTrait
class_name StrategicTrait
## Resource that defines traits for [Personality] class, it's behavioural
## properties, and display information
##
## Intended to be used as a creatable asset in the file system that is
## assigned to the personality trait member values of [Personality]
@export var moving_bias:String

func get_direction(battle_field:BattleField):
	if moving_bias == "":
		var rand = randf()
		if rand < 0.5:
			return 1
		else:
			return -1
	
	var dir:int = battle_field.get_direction_to_object(moving_bias)
	return dir
