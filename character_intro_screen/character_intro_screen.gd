extends Node2D
## Shows player their created character

@onready var backstory_generator: Node = %BackstoryGenerator
@onready var backstory_label: DialogueText = %BackstoryLabel
@onready var name_text_label: RichTextLabel = %NameTextLabel

@onready var offensive_trait: TraitDisplay = %OffensiveTrait
@onready var defensive_trait: TraitDisplay = %DefensiveTrait
@onready var strategic_trait: TraitDisplay = %StrategicTrait

@onready var character_sprite: Sprite2D = $LoadSprite


func _ready() -> void:
	initialize()


func initialize() -> void:
	var player_data = get_player_data()

	if player_data == null:
		return

	# Visuals
	character_sprite.texture = player_data.character_texture
	name_text_label.text = "The journey of [color=gold]" + player_data.name + "[/color]."
 
	# Personality
	offensive_trait.initialize_display(
		player_data.personality.offensive_trait,
		player_data.personality.offensive_weight
	)

	defensive_trait.initialize_display(
		player_data.personality.defensive_trait,
		player_data.personality.defensive_weight
	)

	strategic_trait.initialize_display(
		player_data.personality.strategic_trait,
		player_data.personality.strategic_weight
	)

	# Backstory
	backstory_label.say("   " + backstory_generator.generate_backstory(
		player_data.personality))
	
	GlobalSessionInterface.initialize()
	GlobalSessionInterface.visible = true


func get_player_data():
	var run_progress = GlobalSessionManager.run_progress

	if run_progress == null:
		return null

	return run_progress.player_data


func _on_continue_button_up() -> void:
	GlobalSceneLoader.load_scene(GlobalSceneLoader.MAP_SCENE_PATH)
	pass # Replace with function body.
