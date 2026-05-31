extends Control


@onready var game_mode_selector: Control = %GameModeSelector
@onready var character_creator: Control = %CharacterCreator


func _ready() -> void:
	game_mode_selector.visible = true
	character_creator.visible = false
	character_creator.character_created.connect(_on_character_created)
	MusicManager.change_song(MusicManager.track_list.new_game_scene)


func _on_normal_mode_button_up() -> void:
	character_creator.visible = true
	pass # Replace with function body.


func _on_quick_start_mode_button_up() -> void:
	await character_creator.randomize_input()
	await character_creator._on_save_button_up()
	#GlobalSceneLoader.load_scene(GlobalSceneLoader.Saved_Character_Scene)


func _on_ai_mode_button_up() -> void:
	character_creator.visible = true
	GlobalSessionManager.pending_ai_mode = true


func _on_main_menu_button_up() -> void:
	GlobalSceneLoader.load_scene(GlobalSceneLoader.MAIN_MENU_PATH)
	pass # Replace with function body.


func _on_character_created(data:PlayerInitializationData):
	game_mode_selector.visible = false
	character_creator.visible = false
	
	GlobalSessionManager.initialize(data)
	GlobalSceneLoader.load_scene(GlobalSceneLoader.Saved_Character_Scene)
