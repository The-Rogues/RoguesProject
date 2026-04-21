extends Control

@onready var character_result: CharacterScreen = $CharacterResult

# Character sprite and name varients
@export var character_sprite_varients:Array[Texture2D]
@export var name_varients:Array[String]
@export var offensive_traits:Array[PersonalityTrait]
@export var defensive_traits:Array[PersonalityTrait]
@export var strategic_traits:Array[PersonalityTrait]

# Dictionary that maps character trait to Backstory entry
# TODO: Have the AI look at all character traits and write its own backstory
const backstories := {
	"Brutish": "They enter to prove their strength, believing only pain and broken foes can affirm who they are.",
	"Skittish": "Reluctant explorer.",
	"Greedy": "Promises of wealth lure them inward, certain that gold is worth any risk the tower demands.",
}

func _ready() -> void:
	randomize_character()


func randomize_character() -> void:
	var _name = name_varients.pick_random()
	var offensive_trait:PersonalityTrait = offensive_traits.pick_random()
	var defensive_trait:PersonalityTrait = defensive_traits.pick_random()
	var strategic_trait:PersonalityTrait = strategic_traits.pick_random()
	var offense:int = randi_range(1, 10)
	var defense:int = randi_range(1, 10)
	var strategy:int = randi_range(1, 10)
	
	var max_weight:int = offense
	var max_trait:PersonalityTrait = offensive_trait
	
	if max_weight < defense:
		max_trait = defensive_trait
		max_weight = defense
	if max_weight < strategy:
		max_trait = strategic_trait
	
	var backstory = backstories[max_trait.name]
	var character_texture:Texture2D = character_sprite_varients.pick_random()
	
	var personality_data: PersonalityData = PersonalityData.new()
	personality_data.initialize(
		offensive_trait,
		defensive_trait,
		strategic_trait,
		"OFFENSIVE"
	)
	
	var data := PlayerInitializationData.new(
			_name,
			backstory,
			character_texture,
			personality_data,
			personality_data.get_starting_deck()
	)
	GlobalSessionManager.initialize(data)
	
	character_result.initialize()
	character_result.visible = true
	pass # Replace with function body.
