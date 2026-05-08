extends RefCounted
class_name PlayerInitializationData

var name:String
var backstory:String
var display_texure:Texture2D
var melee_weapon_texture:Texture2D = null
var ranged_weapon_texture:Texture2D = null
var personality:PersonalityData


func _init(
	_name:String,
	_backstory:String,
	_display_texure:Texture2D,
	_melee_weapon_texture:Texture2D,
	_ranged_weapon_texture:Texture2D,
	_personality:PersonalityData,
) -> void:
	name = _name
	backstory = _backstory
	display_texure = _display_texure
	melee_weapon_texture = _melee_weapon_texture
	ranged_weapon_texture = _ranged_weapon_texture
	personality = _personality
