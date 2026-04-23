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
const Character_Builder = "res://main_menu/character_creators/character_builder.tscn"
const Random_Character_Builder = "res://main_menu/character_creators/random_character_creator.tscn"
const AI_Character_Builder = "res://main_menu/character_creators/ai_character_creator.tscn"
const New_Game_Scene = "res://character_creator/new_game_scene.tscn"
const Saved_Character_Scene = "res://character_creator/saved_character_screen.tscn"

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
	
	battle_config = battle_builder.create_battle_config()
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
