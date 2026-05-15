extends Control
class_name CharacterScreen
## Displays information on the player's character after it's been generated.
## Intended use is to have a different scene initialize a run then transition
## into this scene.

@onready var character_image: TextureRect = $Card/MarginContainer/VBoxContainer/CharacterImage
@onready var name_label: Label = $Card/MarginContainer/VBoxContainer/Name
@onready var offensive_trait: TraitDisplay = $Card/MarginContainer/VBoxContainer/HBoxContainer/OffensiveTrait
@onready var defensive_trait: TraitDisplay = $Card/MarginContainer/VBoxContainer/HBoxContainer/DefensiveTrait
@onready var strategic_trait: TraitDisplay = $Card/MarginContainer/VBoxContainer/HBoxContainer/StrategicTrait
@onready var backstory: Label = $Card/MarginContainer/VBoxContainer/Backstory
@onready var deck_viewer: CardViewer = $DeckViewer


func initialize():
	var preview := get_character_preview()
	var deck_cards := get_card_instances()
	
	if preview and !deck_cards.is_empty():
		character_image.texture = preview.display_texure
		name_label.text = preview.name
		backstory.text = preview.backstory
		
		offensive_trait._on_trait_data_updated(
				preview.personality.offensive_trait,
				preview.personality.offensive_weight)
		defensive_trait._on_trait_data_updated(
				preview.personality.defensive_trait,
				preview.personality.defensive_weight)
		strategic_trait._on_trait_data_updated(
				preview.personality.strategic_trait,
				preview.personality.strategic_weight)
		
		
		
		deck_viewer.on_cards_updated(deck_cards)


func get_character_preview() -> PlayerInitializationData:
	var run_progress = GlobalSessionManager.run_progress
	
	if run_progress == null:
		return null
	
	return PlayerInitializationData.new(
			run_progress.player_name,
			run_progress.player_backstory,
			run_progress.player_texture,
			run_progress.player_melee_weapon_texture,
			run_progress.player_ranged_weapon_texture,
			run_progress.player_data.personality
	)


func get_card_instances() -> Array[CardInstance]:
	var run_progress = GlobalSessionManager.run_progress
	
	if run_progress == null:
		return []
	
	return run_progress.player_data.get_cards_as_instances()


func _on_view_deck_clicked() -> void:
	deck_viewer.visible = true
	pass # Replace with function body.


func _on_begin_run_clicked() -> void:
	GlobalSceneLoader.load_scene(GlobalSceneLoader.MAP_SCENE_PATH)
	pass # Replace with function body.
