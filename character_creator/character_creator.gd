extends Control

signal character_created(data:PlayerInitializationData)


@export var offensive_traits:Array[PersonalityTrait]
@export var defensive_traits:Array[PersonalityTrait]
@export var strategic_traits:Array[PersonalityTrait]

@onready var character_texture_selector: Control = %CharacterTextureSelector
@onready var melee_weapon_texture_selector: Control = %MeleeWeaponTextureSelector
@onready var ranged_weapon_texture_selector: Control = %RangedWeaponTextureSelector

@onready var melee_weapon_sprite: TextureRect = %MeleeWeaponSprite
@onready var ranged_weapon_sprite: TextureRect = %RangedWeaponSprite


@onready var character_sprite: TextureRect = %CharacterSprite
@onready var character_name_label: Label = %CharacterNameLabel
@onready var aggression_survey: HBoxContainer = %AggressionSurvey
@onready var resolve_survey: HBoxContainer = %StabilitySurvey
@onready var quirkiness_survey: HBoxContainer = %MotivationSurvey
@onready var save_button: Button = %Save
@onready var name_editor: Control = %NameEditor

var offensive_trait:PersonalityTrait = null
var defensive_trait:PersonalityTrait = null
var strategic_trait:PersonalityTrait = null


const name_presets:Array[String] = [
	"Noah",
	"Elijah",
	"Jacob",
	"Asher",
	"Sarah",
	"Ruth",
	"Boaz",
	"Moses",
	"Maria",
	"John",
	"Robin",
]


func _ready() -> void:
	character_name_label.text = name_presets.pick_random()
	name_editor.text_edit.text = character_name_label.text
	character_texture_selector.initialize()
	melee_weapon_texture_selector.initialize()
	ranged_weapon_texture_selector.initialize()
	
	character_sprite.texture = character_texture_selector.selected_texture
	melee_weapon_sprite.texture = melee_weapon_texture_selector.selected_texture
	ranged_weapon_sprite.texture = ranged_weapon_texture_selector.selected_texture
	
	character_texture_selector.saved_texture.connect(
			_on_character_texture_saved)
	melee_weapon_texture_selector.saved_texture.connect(
			_on_weapon_texture_saved)
	ranged_weapon_texture_selector.saved_texture.connect(
			_on_ranged_weapon_texture_saved)
	
	name_editor.name_saved.connect(_on_name_set)
	update_save_button()



func randomize_input():
	character_name_label.text = name_presets.pick_random()
	name_editor.text_edit.text = character_name_label.text
	character_texture_selector.select_random()
	melee_weapon_texture_selector.select_random()
	ranged_weapon_texture_selector.select_random()
	aggression_survey.select_random()
	resolve_survey.select_random()
	quirkiness_survey.select_random()
	update_save_button()


func update_save_button():
	if (!character_name_label.text.is_empty() and
		offensive_trait and
		defensive_trait and
		strategic_trait):
		save_button.disabled = false
	else:
		save_button.disabled = true


func _on_character_texture_saved(_texture:Texture2D):
	character_sprite.texture = _texture


func _on_weapon_texture_saved(_texture:Texture2D):
	melee_weapon_sprite.texture = _texture
	pass


func _on_ranged_weapon_texture_saved(_texture:Texture2D):
	ranged_weapon_sprite.texture = _texture


func _on_name_set(_name:String):
	character_name_label.text = _name
	name_editor.text_edit.text = _name


func _on_character_texture_slot_button_down() -> void:
	character_texture_selector.visible = true


func _on_randomize_button_up() -> void:
	randomize_input()
	pass # Replace with function body.


func _on_name_editor_button_down() -> void:
	name_editor.visible = true
	pass # Replace with function body.


func _on_cancel_button_up() -> void:
	visible = false
	GlobalSessionManager.pending_ai_mode = false
	pass # Replace with function body.


func _on_save_button_up() -> void:
	var priority_options: Array[String] = ["OFFENSIVE", "DEFENSIVE", "STRATEGIC"]
	var personality = PersonalityData.new()
	personality.initialize(
		offensive_trait,
		defensive_trait,
		strategic_trait,
		priority_options.pick_random()
	)
	
	var player_data = PlayerInitializationData.new(
		character_name_label.text,
		character_sprite.texture,
		melee_weapon_sprite.texture,
		ranged_weapon_sprite.texture,
		personality
	)
	
	character_created.emit(player_data)
	
	visible = false
	pass # Replace with function body.


func _on_aggression_survey_option_selected(option: int) -> void:
	offensive_trait = offensive_traits[option]
	update_save_button()
	pass # Replace with function body.


func _on_stability_survey_option_selected(option: int) -> void:
	defensive_trait = defensive_traits[option]
	update_save_button()
	pass # Replace with function body.


func _on_motivation_survey_option_selected(option: int) -> void:
	strategic_trait = strategic_traits[option]
	update_save_button()
	pass # Replace with function body.


func _on_melee_weapon_texture_slot_button_down() -> void:
	melee_weapon_texture_selector.visible = true
	pass # Replace with function body.



func _on_ranged_weapon_texture_slot_button_down() -> void:
	ranged_weapon_texture_selector.visible = true
	pass # Replace with function body.
