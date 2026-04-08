extends RefCounted
class_name PlayerInitializationData

var name:String
var backstory:String
var display_texure:Texture2D
var personality:PersonalityData
var starting_deck:Array[CardData]


func _init(
	_name:String,
	_backstory:String,
	_display_texure:Texture2D,
	_personality:PersonalityData,
	_starting_deck:Array[CardData]
) -> void:
	name = _name
	backstory = _backstory
	display_texure = _display_texure
	personality = _personality
	starting_deck = _starting_deck
