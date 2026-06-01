extends Control
class_name SceneLoader
## A Script for managing scene transitions with a laoding screen.
##
## Maintains paths to commonly visited scenes for convenvenience such as battle
## scene, main menu, map scene, character generator, and item shop.
## If you are implementing bosses, please include their scenes in this script.


# Signals for tracking load progress
signal started_loading_scene
signal load_progresses_updated(progress)
signal scene_loaded

# Stores data on the next battle to be loaded
var show_loading:bool = true

const MAIN_MENU_PATH = "res://main_menu/main_menu_scene.tscn"
const AI_Character_Builder = "res://main_menu/character_creators/ai_character_creator.tscn"
const New_Game_Scene = "res://character_creator/new_game_scene.tscn"
const Saved_Character_Scene = "res://character_creator/saved_character_screen.tscn"
const CHARACTER_INTRO_SCENE = "res://character_intro_screen/character_intro_screen.tscn"

const MAP_SCENE_PATH = "res://Map/map_screen/MapScreen.tscn"
const BATTLE_SCENE_PATH = "res://battle_scene/battle_scene.tscn"
const ITEM_SHOP_PATH = "res://shop_scenes/item_shop/item_shop_scene.tscn"

@export var loading_sprite_varients:Array[Texture2D]
@export var battle_builder: BattleBuilder

@onready var screen_fade: ScreenFade = $ScreenFade
@onready var loading_screen_layer: CanvasLayer = $LoadingScreenLayer
@onready var animation_player: AnimationPlayer = $LoadingScreenLayer/Control/AnimationPlayer
@onready var load_sprite: Sprite2D = $LoadingScreenLayer/Control/LoadSprite
@onready var loading_progress_bar: ProgressBar = $LoadingScreenLayer/Control/LoadingBar/LoadingProgressBar


var battle_config:BattleConfig
var loaded_scene
var loading_scene_path:String = ""
var loading_scene:bool = false

# -------------------------------------------------
# _ready & _process functions
# -------------------------------------------------
func _ready() -> void:
	load_progresses_updated.connect(_on_load_progress_updated)
	scene_loaded.connect(_on_scene_loaded)
	started_loading_scene.connect(_on_started_loading_scene)


func _process(_delta: float) -> void:
	if !loading_scene:
		return
	
	var progress = []
	var status = ResourceLoader.load_threaded_get_status(loading_scene_path, progress)
	
	if status == ResourceLoader.ThreadLoadStatus.THREAD_LOAD_IN_PROGRESS:
		load_progresses_updated.emit(progress[0] * 100)
	
	if status == ResourceLoader.ThreadLoadStatus.THREAD_LOAD_LOADED:
		loaded_scene = ResourceLoader.load_threaded_get(loading_scene_path)
		scene_loaded.emit()
		loading_scene = false

# -------------------------------------------------
# Scene load requests
# -------------------------------------------------
func load_scene(scene_path:String, show_loading:bool = true):
	ResourceLoader.load_threaded_request(scene_path)
	loading_scene = true
	loading_scene_path = scene_path
	started_loading_scene.emit()
	self.show_loading = show_loading


func load_battle_scene():
	if loading_scene:
		return
	
	var run: RunProgress = GlobalSessionManager.run_progress
	
	
	if run != null and run.room_in_progress \
	and run.battle != null and run.battle.battle_config != null:
		battle_config = BattleConfig.new(
			run.battle.battle_config.enemy_encounter,
			run.battle.battle_config.battle_field_config,
			run.player_data
		)
	else:
		# Fresh battle — generate and save config
		battle_config = battle_builder.create_battle_config()
		if run != null:
			if run.battle == null:
				run.battle = BattleSaveData.new()
			run.battle.is_active = true
			run.battle.resume_node_index = run.pending_node_index
			var config_save : BattleConfigSaveData = BattleConfigSaveData.new()
			config_save.enemy_encounter = battle_config.enemy_encounter     
			config_save.battle_field_config = battle_config.battle_field_config
			run.battle.battle_config = config_save
			GlobalSaveManager.save_run(run)
	
	ResourceLoader.load_threaded_request(BATTLE_SCENE_PATH)
	loading_scene_path = BATTLE_SCENE_PATH
	loading_scene = true
	started_loading_scene.emit()


func load_shop_scene():
	if loading_scene:
		return
	
	ResourceLoader.load_threaded_request(ITEM_SHOP_PATH)
	loading_scene_path = ITEM_SHOP_PATH
	loading_scene = true
	started_loading_scene.emit()

# -------------------------------------------------
# Loading scene events
# -------------------------------------------------
func _on_started_loading_scene():
	var load_texture:Texture2D
	if GlobalSessionManager.started_session:
		load_texture = GlobalSessionManager.get_character_texture()
	else:
		load_texture = loading_sprite_varients.pick_random()
	load_sprite.texture = load_texture
	await screen_fade.fade_out()
	loading_screen_layer.visible = show_loading
	animation_player.play("loading")


func _on_scene_loaded():
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_packed(loaded_scene)
	
	loading_screen_layer.visible = false
	animation_player.stop()
	screen_fade.fade_in()


func _on_load_progress_updated(progress):
	loading_progress_bar.value = progress
