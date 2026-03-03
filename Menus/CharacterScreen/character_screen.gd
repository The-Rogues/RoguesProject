extends Control
class_name CharacterScreen
## Displays information on the player's character after it's been generated.
## Intended use is to have a different scene initialize a run then transition
## into this scene.

@onready var character_image: TextureRect = $Card/MarginContainer/VBoxContainer/CharacterImage
@onready var name_label: Label = $Card/MarginContainer/VBoxContainer/Name
@onready var traits_display: TraitDisplay = $Card/MarginContainer/VBoxContainer/TraitsDisplay
@onready var backstory: Label = $Card/MarginContainer/VBoxContainer/Backstory
@onready var deck_viewer: CardDeckViewerUI = $DeckViewer


func initialize():
	if GlobalSessionManager.run_progress:
		character_image.texture = GlobalSessionManager.get_character_texture()
		name_label.text = GlobalSessionManager.run_progress.character_name
		backstory.text = GlobalSessionManager.run_progress.character_backstory
		deck_viewer._initialize(GlobalSessionManager.run_progress.card_deck)
		traits_display.initialize(GlobalSessionManager.run_progress.personality_data)


func _on_view_deck_clicked() -> void:
	deck_viewer._on_activation_button_up()
	pass # Replace with function body.


func _on_begin_run_clicked() -> void:
	GlobalSceneLoader.load_scene(GlobalSceneLoader.MAP_SCENE_PATH)
	pass # Replace with function body.
