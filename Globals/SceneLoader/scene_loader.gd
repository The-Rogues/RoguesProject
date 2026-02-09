# Intended to be used as a global object for loading scenes & battles
extends Node2D
class_name SceneLoader

# Signals for tracking load progress
signal started_loading_scene
signal load_progresses_updated(progress)
signal scene_loaded

# Stores data on the next battle to be loaded
var pending_battle_configuration:BattleSceneConfiguration
var pending_shop_data:ShopData

# TODO: 
const FLOOR_1_SPAWN_POOL = preload("res://BattleSystem/Configuration/SpawnPools/floor_1_spawn_pool.tres")
const FLOOR_1_SHOP_DATA = preload("res://Map/ItemShop/ShopDatas/floor_1_shop_data.tres")

const MAIN_MENU_PATH = "res://Menus/main_menu_scene.tscn"
const MAP_SCENE_PATH = "res://Map/map_screen/MapScreen.tscn"
const BATTLE_SCENE_PATH = "res://BattleSystem/Scenes/battle_scene.tscn"
const CHARACTER_GENERATOR_PATH = "res://Menus/character_generator_screen.tscn"
const ITEM_SHOP_PATH = "res://Map/ItemShop/Scenes/item_shop_scene.tscn"

@export var loading_sprite_varients:Array[Texture2D]
@onready var loading_screen_layer: CanvasLayer = $LoadingScreenLayer
@onready var character_animator: AnimationPlayer = $LoadingScreenLayer/Control/Character/CharacterAnimator
@onready var load_progress_bar: ProgressBar = $LoadingScreenLayer/Control/VBoxContainer/LoadProgressBar
@onready var sprite_2d: Sprite2D = $LoadingScreenLayer/Control/Character/Sprite2D

var loaded_scene
var loading_scene_path:String = ""
var loading_scene:bool = false

func _ready() -> void:
	load_progresses_updated.connect(_on_load_progress_updated)
	scene_loaded.connect(_on_scene_loaded)
	started_loading_scene.connect(_on_started_loading_scene)

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

func load_scene(scene_path:String):
	ResourceLoader.load_threaded_request(scene_path)
	loading_scene = true
	loading_scene_path = scene_path
	started_loading_scene.emit()

func load_battle_scene():
	if loading_scene:
		return
	
	create_battle_scene_configuration()
	ResourceLoader.load_threaded_request(BATTLE_SCENE_PATH)
	loading_scene_path = BATTLE_SCENE_PATH
	loading_scene = true
	started_loading_scene.emit()

func load_shop_scene():
	if loading_scene:
		return
	
	# TODO: Change item pool depending on floor the player is on
	pending_shop_data = FLOOR_1_SHOP_DATA
	ResourceLoader.load_threaded_request(ITEM_SHOP_PATH)
	loading_scene_path = ITEM_SHOP_PATH
	loading_scene = true
	started_loading_scene.emit()

func _on_started_loading_scene():
	var load_texture:Texture2D
	if GlobalSessionManager.started_session:
		load_texture = GlobalSessionManager.get_character_sprite()
	else:
		load_texture = loading_sprite_varients.pick_random()
	sprite_2d.texture = load_texture
	
	loading_screen_layer.visible = true
	character_animator.play("battle_entity/march")

func create_battle_scene_configuration():
	# TODO: Change spawn pool depending on floor the player is on
	var battle_config = BattleSceneConfiguration.new(
		GlobalSessionManager.get_character(),
		GlobalSessionManager.get_heald_items(),
		FLOOR_1_SPAWN_POOL.get_enemies() as Array[EnemyData],
		FLOOR_1_SPAWN_POOL.get_object_layout()
	)
	pending_battle_configuration = battle_config
	
	return battle_config

func get_shop_items():
	var shop_items:Array[ItemData] = pending_shop_data.get_shop_items()
	pending_shop_data = null
	return shop_items

func _on_scene_loaded():
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_packed(loaded_scene)
	loading_screen_layer.visible = false
	character_animator.stop()

func _on_load_progress_updated(progress):
	load_progress_bar.value = progress
