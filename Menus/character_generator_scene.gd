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

var TRAITS = {
	"Brute": load("res://PersonalitySystem/PersonalityTraits/Traits/Offensive/Brute/brute_trait_data.tres"),
	"Valorous": load("res://PersonalitySystem/PersonalityTraits/Traits/Offensive/Valorous/valorous_trait_data.tres"),
	"Merciful": load("res://PersonalitySystem/PersonalityTraits/Traits/Offensive/Merciful/merciful_trait_data.tres"),
	"Careful": load("res://PersonalitySystem/PersonalityTraits/Traits/Defensive/Careful/careful_trait_data.tres"),
	"Stoic": load("res://PersonalitySystem/PersonalityTraits/Traits/Defensive/Stoic/stoic_trait_data.tres"),
	"Skiddish": load("res://PersonalitySystem/PersonalityTraits/Traits/Defensive/Skiddish/skiddish_trait_data.tres"),
	"Opportunist": load("res://PersonalitySystem/PersonalityTraits/Traits/Strategic/Opportunist/opportunist_trait_data.tres"),
	"Greedy": load("res://PersonalitySystem/PersonalityTraits/Traits/Strategic/Greedy/greedy_trait_data.tres"),
	"LaidBack": load("res://PersonalitySystem/PersonalityTraits/Traits/Strategic/LaidBack/laid_back_trait_data.tres"),
}

# Character sprite and name varients
@export var character_sprite_varients:Array[Texture2D]
@export var name_varients:Array[String]

# Dictionary that maps character trait to Backstory entry
# TODO: Have the AI look at all character traits and write its own backstory
const backstories := {
	"Brute": "Entered the tower seeking foes worthy of their strength, believing every shattered door and fallen monster proves their dominance.",
	"Valorous": "Honor bound, entered the tower after hearing that citizens from their village entered despite the warnings.",
	"Merciful": "They descend into the dungeon hoping to befriend the monsters and redeem travelers",
	"Careful": "Enticed by the tower, but weary of its dangers, they seek to satisfy their curiosity.",
	"Stoic": "Knowing the dungeon will change them, confident that whatever happens, they will learn and adjust to survive.",
	"Skiddish": "Fearing something far worse is coming for them, seeks the opportunity to esnure their soul will be saved",
	"Opportunist": "Crossing the threshold with a single goal in mind, ascending their spirit by going through a spiritual trial.",
	"Greedy": "Entered for the promise of treasure, certain that any risk is worth the wealth buried in the dark.",
	"LaidBack": "They step into the dungeon with no plan at all, trusting things will turn out alright in the end."
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
	
	var offensive_trait:TraitData = TRAITS[offensive_trait_name]
	var defensive_trait:TraitData = TRAITS[defensive_trait_name]
	var strategic_trait:TraitData = TRAITS[strategic_trait_name]
	
	offensive_trait = offensive_trait.duplicate(true)
	defensive_trait = defensive_trait.duplicate(true)
	strategic_trait = strategic_trait.duplicate(true)
	# Setting Trait weights
	offensive_trait.weight = offensive_weight.value
	defensive_trait.weight = defensive_weight.value
	strategic_trait.weight = strategic_weight.value
	
	# Creates new battle entity that will persist through scenes
	var character_data:CharacterData = CharacterData.new()
	character_data.initialize(
		name_label.text,
		offensive_trait,
		defensive_trait,
		strategic_trait,
	)
	character_data.display_texture = character_sprite.texture
	
	GlobalSessionManager.initialize_new_run(
		character_data, 
		backstory_label.text
	)
	
	GlobalSaveManager.save_run(GlobalSessionManager.run_progress)
	
	# Fletcher - Changed from load battle scene to load map scene.
	GlobalSceneLoader.load_scene(GlobalSceneLoader.MAP_SCENE_PATH)
