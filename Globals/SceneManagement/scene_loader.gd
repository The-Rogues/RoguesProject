extends Node2D
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
var pending_battle_configuration:BattleSceneConfiguration
var pending_shop_data:ShopData
var show_loading:bool = true

const FLOOR_1_SPAWN_POOL = preload("res://Battle/Config/SpawnPools/floor_1_spawn_pool.tres")
const ITEM_SHOP_DATA = preload("res://Map/Shop/ItemPools/item_shop_data.tres")

const MAIN_MENU_PATH = "res://Menus/MainMenu/main_menu_scene.tscn"
const MAP_SCENE_PATH = "res://Map/map_screen/MapScreen.tscn"
const BATTLE_SCENE_PATH = "res://Battle/Scenes/battle_scene.tscn"
const CHARACTER_GENERATOR_PATH = "res://Menus/RandomCharacterBuilder/character_generator_screen.tscn"
const RANDOM_CHARACTER_PATH = "res://Menus/RandomCharacterBuilder/random_character_scene.tscn"
const ITEM_SHOP_PATH = "res://Map/Shop/Scenes/shop_scene.tscn"
const AI_CHARACTER_GENERATOR_PATH = "res://Menus/AICharacterGenerator/ai_character_scene.tscn"

@export var loading_sprite_varients:Array[Texture2D]
@onready var loading_screen_layer: CanvasLayer = $LoadingScreenLayer
@onready var character_animator: AnimationPlayer = $LoadingScreenLayer/Control/Character/CharacterAnimator
@onready var load_progress_bar: ProgressBar = $LoadingScreenLayer/Control/VBoxContainer/LoadProgressBar
@onready var sprite_2d: Sprite2D = $LoadingScreenLayer/Control/Character/Sprite2D
@onready var screen_fade: ScreenFade = $ScreenFade


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
	
	screen_fade.fade_in()


func _process(delta: float) -> void:
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
	
	_create_battle_scene_configuration()
	ResourceLoader.load_threaded_request(BATTLE_SCENE_PATH)
	loading_scene_path = BATTLE_SCENE_PATH
	loading_scene = true
	started_loading_scene.emit()


func _create_battle_scene_configuration():
	# TODO: Change spawn pool depending on floor the player is on
	var battle_config = BattleSceneConfiguration.new(
		FLOOR_1_SPAWN_POOL.get_enemy_encounter(),
		FLOOR_1_SPAWN_POOL.get_object_layout(),
		GlobalSessionManager.run_progress.personality_data,
		GlobalSessionManager.run_progress.character_entity_data,
		GlobalSessionManager.run_progress.held_items,
		GlobalSessionManager.run_progress.card_deck,
		GlobalSessionManager.run_progress.max_energy,
		GlobalSessionManager.run_progress.current_health
	)
	
	pending_battle_configuration = battle_config
	
	return battle_config


func load_shop_scene():
	if loading_scene:
		return
	
	# TODO: Change item pool depending on floor the player is on
	pending_shop_data = ITEM_SHOP_DATA
	ResourceLoader.load_threaded_request(ITEM_SHOP_PATH)
	loading_scene_path = ITEM_SHOP_PATH
	loading_scene = true
	started_loading_scene.emit()

# -------------------------------------------------
# Getters
# -------------------------------------------------
func get_shop_items():
	var shop_items:Array[ItemData] = pending_shop_data.get_shop_items()
	pending_shop_data = null
	return shop_items

# -------------------------------------------------
# Loading scene events
# -------------------------------------------------
func _on_started_loading_scene():
	var load_texture:Texture2D
	if GlobalSessionManager.started_session:
		load_texture = GlobalSessionManager.get_character_texture()
	else:
		load_texture = loading_sprite_varients.pick_random()
	sprite_2d.texture = load_texture
	await screen_fade.fade_out()
	loading_screen_layer.visible = show_loading
	character_animator.play("loading")


func _on_scene_loaded():
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_packed(loaded_scene)
	loading_screen_layer.visible = false
	character_animator.stop()
	screen_fade.fade_in()


func _on_load_progress_updated(progress):
	load_progress_bar.value = progress
