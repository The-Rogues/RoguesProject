extends Control


@onready var game_mode_selector: Control = %GameModeSelector
@onready var character_creator: Control = %CharacterCreator
@onready var starting_run_label: Label = %StartingRunLabel
@onready var character_result: CharacterScreen = %CharacterResult


func _ready() -> void:
	game_mode_selector.visible = true
	character_creator.visible = false
	starting_run_label.visible = false
	character_result.visible = false
	character_creator.character_created.connect(_on_character_created)


func _on_normal_mode_button_up() -> void:
	character_creator.visible = true
	pass # Replace with function body.


func _on_ai_mode_button_up() -> void:
	GlobalSceneLoader.load_scene(GlobalSceneLoader.AI_Character_Builder)
	pass # Replace with function body.


func _on_main_menu_button_up() -> void:
	GlobalSceneLoader.load_scene(GlobalSceneLoader.MAIN_MENU_PATH)
	pass # Replace with function body.


func _on_character_created(data:PlayerInitializationData):
	game_mode_selector.visible = false
	character_creator.visible = false
	starting_run_label.visible = true
	
	GlobalSessionManager.initialize(data)
	await get_tree().create_timer(1).timeout
	character_result.initialize()
	starting_run_label.visible = false
	character_result.visible = true
	GlobalSessionInterface.visible = true
