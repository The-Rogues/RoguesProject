extends Node2D
class_name SessionManager
## Serves as a mediator between scenes and run progress
##
## Inteded use for safe access and manipulation of run progress as the player
## plays through the game

signal current_health_updated(new_value:int)
signal max_health_updated(new_value:int)
signal increased_item_capacity(new_capacity:int)
signal traits_updated
signal gold_updated(new_value:int)
signal gold_added(added_amount:int)

var run_progress: RunProgress
var started_session:bool = false
var pending_node_index = -1

# -------------------------------------------------
# Initializing & deleting game session
# -------------------------------------------------
func initialize_new_run(
		character_texture: Texture2D,
		character_name: String,
		character_backstory: String,
		personality_data: PersonalityData,
		card_deck: CardDeck
) -> void:
	run_progress = RunProgress.new()
	card_deck.add_card(load("res://ai/ai-cards/inventive_attack_data.tres"))
	run_progress.initialize_new_run(
		character_texture,
		character_name,
		character_backstory,
		personality_data,
		card_deck
	)
	
	initialize_map()
	
	started_session = true
	GlobalSaveManager.save_run(run_progress)


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
	
	if corr_node.node_data.mini_event != null:
		var mini_event_scene: PackedScene = load("res://Map/mini_event_screen/MiniEventScreen.tscn")
		var mini_instance: Control = mini_event_scene.instantiate()
		get_tree().current_scene.add_child(mini_instance)
		mini_instance.init_screen(corr_node.node_data)
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
	
	return run_progress.character_entity_data.display_texture

# -------------------------------------------------
# Updating character
# -------------------------------------------------

func increase_max_health(amount:int):
	if run_progress == null:
		return
	
	run_progress.character_entity_data.max_health += amount
	GlobalSaveManager.save_run(run_progress)
	max_health_updated.emit(run_progress.character_entity_data.max_health)


func increase_max_energy(amount:int):
	if run_progress == null:
		return
	
	run_progress.max_energy += amount
	GlobalSaveManager.save_run(run_progress)


func increase_item_capacity():
	if run_progress == null:
		return
	
	run_progress.maximum_item_capacity += 1
	run_progress.total_items_collected += 1
	GlobalSaveManager.save_run(run_progress)
	increased_item_capacity.emit(run_progress.maximum_item_capacity)


func change_offensive_trait(new_trait:PersonalityTrait, weight:int = -1):
	run_progress.personality_data.offensive_trait = new_trait
	
	if weight >= 1 and weight <= 10:
		run_progress.personality_data.offensive_weight = weight
	
	run_progress.total_personality_shifts += 1
	GlobalSaveManager.save_run(run_progress)
	traits_updated.emit()


func change_defensive_trait(new_trait:PersonalityTrait, weight:int = -1):
	run_progress.personality_data.defensive_trait = new_trait
	
	if weight >= 1 and weight <= 10:
		run_progress.personality_data.defensive_weight = weight
	
	run_progress.total_personality_shifts += 1
	GlobalSaveManager.save_run(run_progress)
	traits_updated.emit()


func change_strategic_trait(new_trait:PersonalityTrait, weight:int = -1):
	run_progress.personality_data.strategic_trait = new_trait
	
	if weight >= 1 and weight <= 10:
		run_progress.personality_data.strategic_weight = weight
	
	run_progress.total_personality_shifts += 1
	GlobalSaveManager.save_run(run_progress)
	traits_updated.emit()


func save_character_health(current_health:int):
	if run_progress == null:
		return
	
	run_progress.current_health = current_health
	current_health_updated.emit(current_health)

# -------------------------------------------------
# Managing gold & items
# -------------------------------------------------
func increase_gold(amount:int):
	if run_progress == null:
		return
	
	run_progress.gold += amount
	run_progress.total_gold_collected +=amount
	
	gold_updated.emit(run_progress.gold)
	gold_added.emit(amount)
	GlobalSaveManager.save_run(run_progress)


func decrease_gold(amount:int):
	if run_progress == null:
		return
	
	run_progress.gold -= amount
	
	gold_updated.emit(run_progress.gold)
	GlobalSaveManager.save_run(run_progress)


func can_buy(price:int):
	if run_progress == null:
		return false
	
	if run_progress.held_items.size() >= run_progress.maximum_item_capacity:
		print("Not enough item capacity")
		return false
	
	
	if price > run_progress.gold:
		print("Not enough gold to purchase")
		return false
	
	return true


func buy_item(item: ItemData) -> bool:
	if run_progress == null:
		return false
		
	if not can_buy(item.shop_price):
		return false
	
	
	run_progress.gold -= item.shop_price
	run_progress.held_items.append(item)
	
	gold_updated.emit(run_progress.gold)
	run_progress.total_items_collected += 1
	GlobalSaveManager.save_run(run_progress)
	return true


func can_sell_item(item: ItemData) -> bool:
	if run_progress == null:
		return false
	
	return run_progress.held_items.has(item)


func sell_held_item(item: ItemData) -> bool:
	if run_progress == null:
		return false
	
	if not can_sell_item(item):
		return false
	
	_remove_held_item(item)
	increase_gold(item.sell_price)
	
	GlobalSaveManager.save_run(run_progress)
	return true


func _remove_held_item(item:ItemData):
	if run_progress == null:
		return
	
	if run_progress.held_items.has(item):
		run_progress.held_items.erase(item)
