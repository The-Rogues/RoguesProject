# Author: Fabian
# Editor: Fletcher
# Used to provide user a preview of the character they will play with

extends Control
class_name CharacterChanger

@onready var name_label: Label = $Background/MarginContainer/CharacterInfo/VBox/Hbox/VBox/Name
@onready var backstory_label: Label = $Background/MarginContainer/CharacterInfo/VBox/Hbox/VBox/Backstory
@onready var character_sprite: TextureRect = $Background/MarginContainer/CharacterInfo/VBox/Hbox/CharacterSprite

@onready var offensive_option: OptionButton = $Background/MarginContainer/CharacterInfo/VBox2/OffensiveTrait/Option
@onready var offensive_weight: SpinBox = $Background/MarginContainer/CharacterInfo/VBox2/OffensiveTrait/Weight
@onready var defensive_option: OptionButton = $Background/MarginContainer/CharacterInfo/VBox2/DefensiveTrait/Option
@onready var defensive_weight: SpinBox = $Background/MarginContainer/CharacterInfo/VBox2/DefensiveTrait/Weight
@onready var strategic_option: OptionButton = $Background/MarginContainer/CharacterInfo/VBox2/StrategicTrait/Option
@onready var strategic_weight: SpinBox = $Background/MarginContainer/CharacterInfo/VBox2/StrategicTrait/Weight

@onready var start_battle: Button = $StartButtonMargin/StartBattle

# Character sprite and name varients
@export var character_sprite_varients:Array[Texture2D]
@export var name_varients:Array[String]
@export var personality_traits:Dictionary[String, PersonalityTrait]

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
	_on_randomize_button_up()

# Randomizes character data
func _on_randomize_button_up() -> void:
	name_label.text = name_varients.pick_random()
	
	# Randomize trait
	offensive_option.selected = randi_range(0, offensive_option.item_count - 1)
	defensive_option.selected = randi_range(0, defensive_option.item_count - 1)
	strategic_option.selected = randi_range(0, strategic_option.item_count - 1)
	# Randomize trait weight
	offensive_weight.value = randi_range(1, 10)
	defensive_weight.value = randi_range(1, 10)
	strategic_weight.value = randi_range(1, 10)
	
	# Pick backstory based on one selected trait
	var selected_traits: Array[String] = [
		offensive_option.get_item_text(offensive_option.selected),
		defensive_option.get_item_text(defensive_option.selected),
		strategic_option.get_item_text(strategic_option.selected)
	]
	
	var chosen_trait: String = selected_traits.pick_random()
	var backstory:String = backstories.get(chosen_trait)
	# Get backstory
	if backstories != null:
		backstory_label.text = backstory
	else:
		backstory_label.text = "They enter the dungeon with an uncertain past."
	# Pick random sprite varient
	character_sprite.texture = character_sprite_varients.pick_random()
	pass # Replace with function body.

# Begins a new run of the game
func _on_start_battle_button_up() -> void:
	start_battle.disabled = true
	
	# Getting Trait Resources
	var offensive_trait_name = offensive_option.get_item_text(offensive_option.selected)
	var defensive_trait_name = defensive_option.get_item_text(defensive_option.selected)
	var strategic_trait_name = strategic_option.get_item_text(strategic_option.selected)
	
	var offensive_trait:PersonalityTrait = personality_traits[offensive_trait_name]
	var defensive_trait:PersonalityTrait = personality_traits[defensive_trait_name]
	var strategic_trait:PersonalityTrait = personality_traits[strategic_trait_name]
	
	# Creates new battle entity that will persist through scenes
	var personality_data:PersonalityData = PersonalityData.new()
	personality_data.initialize(
			offensive_trait,
			defensive_trait,
			strategic_trait,
			offensive_weight.value,
			defensive_weight.value,
			strategic_weight.value
	)
	
	GlobalSessionManager.initialize_new_run(
		character_sprite.texture,
		name_label.text,
		backstory_label.text,
		personality_data,
		personality_data.get_starting_deck()
	)
	
	# Fletcher - Changed from load battle scene to load map scene.
	GlobalSceneLoader.load_scene(GlobalSceneLoader.MAP_SCENE_PATH)
