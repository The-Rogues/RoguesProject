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
const FLOOR_1_ENEMY_POOL = preload("res://Resources/FloorEnemyPools/floor_pool_1.tres")
const FLOOR_1_SCHEMA = preload("res://Resources/DefaultResources/default_floor_object_schemas.tres")
const FLOOR_1_SHOP_ITEMS = preload("res://Resources/ShopDatas/floor_1_shop_data.tres")

const BATTLE_SCENE_PATH = "res://Screens/battle_scene.tscn"
const CHARACTER_CHANGER_SCREEN = "res://Screens/character_screen.tscn"
const SHOP_SCENE_PATH = "res://Screens/shop_screen.tscn"

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
	
	create_shop_scene_configuration()
	ResourceLoader.load_threaded_request(SHOP_SCENE_PATH)
	loading_scene_path = SHOP_SCENE_PATH
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
	var enemy_group:EnemyGroup 
	#objects
	if GlobalSessionManager.get_current_floor() == 1:
		enemy_group = FLOOR_1_ENEMY_POOL.get_enemy_group(GlobalSessionManager.get_floor_progress())
	# TODO: Add additional if statements for future floors 2, 3, 4
	
	var battle_config = BattleSceneConfiguration.new(
			GlobalSessionManager.get_character(),
			GlobalSessionManager.get_heald_items(),
			enemy_group,
			FLOOR_1_SCHEMA.floor_layout_group.pick_random()
	)
	pending_battle_configuration = battle_config
	return battle_config

func create_shop_scene_configuration():
	var shop_data:ShopData 
	#shop items
	if GlobalSessionManager.get_current_floor() == 1:
		shop_data = FLOOR_1_SHOP_ITEMS.duplicate(true)
	# TODO: Add additional if statements for future floors 2, 3, 4
	
	pending_shop_data = shop_data

func _on_scene_loaded():
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_packed(loaded_scene)
	loading_screen_layer.visible = false
	character_animator.stop()

func _on_load_progress_updated(progress):
	load_progress_bar.value = progress
