extends Control

@onready var character_result: CharacterScreen = $CharacterResult

# Character sprite and name varients
@export var character_sprite_varients:Array[Texture2D]
@export var name_varients:Array[String]
@export var offensive_traits:Array[OffensiveTrait]
@export var defensive_traits:Array[DefensiveTrait]
@export var strategic_traits:Array[StrategicTrait]

# Dictionary that maps character trait to Backstory entry
# TODO: Have the AI look at all character traits and write its own backstory
const backstories := {
	"Brute": "They enter the tower to prove their strength, believing only pain and broken foes can affirm who they are.",
	"Tactical": "Drawn by rumors of powerful adversaries, they climb the tower seeking rivals worthy of their resolve.",
	"Merciful": "They descend not to conquer, but to understand, hoping even monsters might be spared from needless violence.",
	"Stoic": "They know the tower will test them, yet trust their discipline to endure whatever trials await.",
	"Naive": "Curiosity outweighs caution as they step inside, convinced that things will somehow work out.",
	"Fickle": "Sensing danger beyond comprehension, they enter reluctantly, always watching for a place to hide or escape.",
	"Greedy": "Promises of wealth lure them inward, certain that gold is worth any risk the tower demands.",
	"Laidback": "With little concern for danger or reward, they wander into the tower with no plan and no urgency.",
	"Crafty": "They enter prepared, intent on turning the tower’s terrain, tools, and structures into weapons of survival."
}

func _ready() -> void:
	randomize_character()


func randomize_character() -> void:
	var _name = name_varients.pick_random()
	var offensive_trait:OffensiveTrait = offensive_traits.pick_random()
	var defensive_trait:DefensiveTrait = defensive_traits.pick_random()
	var strategic_trait:StrategicTrait = strategic_traits.pick_random()
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
		offense,
		defense,
		strategy
	)
	
	GlobalSessionManager.initialize_new_run(
		character_sprite_varients.pick_random(),
		_name,
		backstory,
		personality_data,
		personality_data.get_starting_deck()
	)
	
	character_result.initialize()
	character_result.visible = true
	pass # Replace with function body.
