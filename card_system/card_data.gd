extends Resource
class_name CardData
## Resource that stores information for a unique playable card.
##
## Includes a card's name, description, cost to play, and combat moves
## to perform. Intended to be used as a creatable asset that is passed
## to CardUI for initialization
enum Type {ATTACK, SKILL, POWER, AI, JUNK}

@export var type:Type
@export var energy_cost:int = 0
@export var name:String = "Card name"
@export_multiline var description:String = "Card Description"
@export var exhaust_after_play:bool = false
@export var play_actions:Array[Action]
#TODO: Experiment with cards having display image 


func get_type_to_string() -> String:
	match type:
		Type.ATTACK:
			return "Attack"
		Type.SKILL:
			return "Skill"
		Type.POWER:
			return "Power"
		Type.AI:
			return "AI"
		_:
			return "Junk"
