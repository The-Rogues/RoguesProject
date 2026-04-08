extends Node2D
class_name SessionManager
## Serves as a mediator between scenes and run progress. Intended use
## for storing run progress

var run_progress: RunProgress = null
var started_session:bool = false

# -------------------------------------------------
# Initializing & deleting game session
# -------------------------------------------------
func initialize(data:PlayerInitializationData) -> void:
	run_progress = create_run(data)
	initialize_map()
	
	started_session = true
	GlobalSaveManager.save_run(run_progress)
	GlobalSessionInterface.initialize()


func create_run(data:PlayerInitializationData) -> RunProgress:
	var run:RunProgress = RunProgress.new()
	
	run.player_data = PlayerData.new(data.personality, data.starting_deck)
	run.player_data.name = data.name
	run.player_name = data.name
	run.player_texture = data.display_texure
	run.player_backstory = data.backstory
	
	run.total_gold_collected = 0
	run.total_cards_collected = 0
	run.total_items_collected = 0
	run.total_personality_shifts = 0
	run.total_rooms_explored = 0
	
	run.initialized = true
	
	# Add AI Card to starting deck
	run.player_data.cards.append(
		load("res://ai/ai-cards/inventive_attack_data.tres")
	)
	
	return run


# Fletcher - Make a unique map for the game session. Add callback to load the battle scene when a node is clicked.
func initialize_map() -> void:
	# Branch executes of no save data
	if !GlobalSaveManager.has_save():
		# Create new map configuration
		run_progress.map_seed = randi()
		run_progress.player_node_index = 0
	
	# Maps always reconstructed from seed
	run_progress.run_map = MapManager.new(run_progress.map_seed)
	run_progress.run_map.set_player_node_index(run_progress.player_node_index)
	_attach_map_callbacks()


func _attach_map_callbacks():
	run_progress.run_map.add_callback(
		func(corr_node: RefCounted):
			# save position on arrival
			run_progress.player_node_index = run_progress.run_map.get_player_node_index()
			# trigger scene
			if corr_node.node_data == 1:
				GlobalSceneLoader.load_battle_scene()
			elif corr_node.node_data == 0:
				GlobalSceneLoader.load_shop_scene()
			elif corr_node.node_data == 2:
				GlobalSceneLoader.load_scene("res://Map/test_screen/TestScreen.tscn")
			run_progress.total_rooms_explored += 1
			GlobalSaveManager.save_run(run_progress)
	)

func erase_run_progress():
	started_session = false
	run_progress = null

# -------------------------------------------------
# Getters
# -------------------------------------------------
func get_floor_progress():
	if run_progress == null:
		return -1
	return run_progress.floor_progress


func get_current_floor():
	if run_progress == null:
		return -1
	return run_progress.current_floor


func get_character_texture():
	if run_progress == null:
		return load("res://Testing/donkey.tres")
	
	return run_progress.player_texture
