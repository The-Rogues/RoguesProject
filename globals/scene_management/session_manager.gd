extends Node2D
class_name SessionManager
## Serves as a mediator between scenes and run progress. Intended use
## for storing run progress

var run_progress: RunProgress = null
var started_session:bool = false


const DEFAULT_STARTING_DECK = preload("res://content/scene_configuration/default_starting_card_deck.tres")


func _ready() -> void:
	GlobalSessionManager.run_progress = GlobalSaveManager.load_run()
	
	if GlobalSessionManager.run_progress:
		connect_run_signals()
		await get_tree().process_frame
		GlobalSessionInterface.initialize()


# -------------------------------------------------
# Initializing & deleting game session
# -------------------------------------------------

func initialize(data:PlayerInitializationData) -> void:
	run_progress = create_run(data)
	initialize_map()
	
	started_session = true
	GlobalSaveManager.save_run(run_progress)
	GlobalSessionInterface.initialize()
	connect_run_signals()


func create_run(data:PlayerInitializationData) -> RunProgress:
	var run:RunProgress = RunProgress.new()
	
	var player_data = PlayerData.new()
	player_data.initialize(data.personality, DEFAULT_STARTING_DECK.cards.duplicate(true))
	player_data.name = data.name
	player_data.character_texture = data.character_texture
	player_data.melee_weapon_texture = data.melee_weapon_texture
	player_data.ranged_weapon_texture = data.ranged_weapon_texture
	
	run.player_data = player_data
	
	run.total_gold_collected = 0
	run.total_cards_collected = 0
	run.total_items_collected = 0
	run.total_personality_shifts = 0
	run.total_rooms_explored = 0
	
	run.initialized = true
	
	
	# Add AI Card to starting deck
	#run.player_data.cards.append(
	#	load("res://ai/ai-cards/inventive_strike/inventive_strike_data.tres")
	#)
	
	return run


func connect_run_signals():
	var run = GlobalSessionManager.run_progress
	
	run.player_data.gold_collected.connect(func(amount):
		run.total_gold_collected += amount)
	
	run.player_data.item_collected.connect(func():
		run.total_items_collected += 1)
	
	run.player_data.card_collected.connect(func():
		run.total_cards_collected += 1)


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
	# _attach_map_callbacks()


#func _attach_map_callbacks():
	#run_progress.run_map.add_callback(
		#func(corr_node: RefCounted):
			## save position on arrival
			#run_progress.player_node_index = run_progress.run_map.get_player_node_index()
			## trigger scene
			#
			#if corr_node.node_data.mini_event != null:
				#var mini_event_scene: PackedScene = load("res://Map/mini_event_screen/MiniEventScreen.tscn")
				#var mini_instance: Control = mini_event_scene.instantiate()
				#get_tree().current_scene.add_child(mini_instance)
				#mini_instance.init_screen(corr_node.node_data)
			#else:
				#var callback: RefCounted = corr_node.node_data.main_event.event_callback.new()
				#callback.process_event()
	#)

# Get the current state of the node. I used this one. Before when click the node, it will update end go to the next one before we actually finish the battle
func select_map_node(corr_node: RefCounted) -> void:
	if run_progress == null or run_progress.run_map == null:
		return
	
	run_progress.pending_node_index = run_progress.run_map.map_structure.get_node_index(corr_node)
	#run_progress.pending_room_type = corr_node.node_data
	run_progress.room_in_progress = true
	GlobalSaveManager.save_run(run_progress)
	
	if corr_node.node_data.mini_event != null and not run_progress.mini_event_completed:
		#var mini_event_scene: PackedScene = load("res://Map/mini_event_screen/MiniEventScreen.tscn")
		#var mini_instance: Control = mini_event_scene.instantiate()
		#get_tree().current_scene.add_child(mini_instance)
		#mini_instance.init_screen(corr_node.node_data)
		var mini_event:PackedScene = load("res://mini_event_system/mini_event_interface.tscn")
		var instance = mini_event.instantiate()
		get_tree().current_scene.add_child(instance)
		instance.initialize(corr_node.node_data)
	else:
		var callback: RefCounted = corr_node.node_data.main_event.event_callback.new()
		callback.process_event()

# Use this in all the event to reset after exist. This function use will condition is meet in the event. 
func complete_current_room() -> void:
	if run_progress == null or run_progress.run_map == null:
		return
	if run_progress.pending_node_index < 0:
		return
	
	run_progress.run_map.set_player_node_index(run_progress.pending_node_index)
	run_progress.player_node_index = run_progress.pending_node_index
	run_progress.total_rooms_explored += 1
	
	run_progress.pending_node_index = -1 # These will be save. I want to use this to prevent player when the back to the game, they choose other location instead. 
	run_progress.pending_room_type = -1
	run_progress.room_in_progress = false
	
	# Clear battle save data
	run_progress.battle = null
		
	# Clear extra item slot.
	#if run_progress.player_data.items.size() == run_progress.player_data.item_capacity:
	#	run_progress.player_data.remove_item(
	#		run_progress.player_data.items[run_progress.player_data.items.size() - 1]
	#	)
	run_progress.shop_save = null
	run_progress.mini_event_completed = false
	
	GlobalSaveManager.save_run(run_progress)

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
	
	return run_progress.player_data.character_texture
