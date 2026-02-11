# Intended to be used as a global object for managing
# the storage & loading of persistent data using a RunProgress resource
# Used to store player character info and game progress

# Author: Fabian
# Editors: Fletcher

extends Node2D
class_name SessionManager

signal gold_updated(new_value:int)

# Stores reloadable information on game progress and the player's character
var run_progress: RunProgress
var started_session:bool = false

# run_map moved to run_progress
# Fletcher - Add data member to hold the game session's map manager.
# var run_map: MapManager

func initialize_new_run(
		character_data:CharacterData,
		backstory:String
		):
	
	run_progress = RunProgress.new(character_data, backstory)
	initialize_map()
	started_session = true

func restart():
	run_progress = null
	started_session = false

# Fletcher - Make a unique map for the game session. Add callback to load the battle scene when a node is clicked.
func initialize_map():
	if run_progress.map_seed == 0: run_progress.map_seed = randi()
	run_progress.run_map = MapManager.new(run_progress.map_seed)
	GlobalSaveManager.save_run(run_progress)
	
	# Attatching map callbacks
	run_progress.run_map = MapManager.new(randi())
	_attach_map_callbacks()
	
	run_progress.run_map.set_player_node_index(run_progress.player_node_index)

func _attach_map_callbacks():
	run_progress.run_map.add_callback(
		func(corr_node: RefCounted):
			# save position on arrival
			run_progress.player_node_index = run_progress.run_map.get_player_node_index()
			GlobalSaveManager.save_run(run_progress)
			# trigger scene
			if corr_node.node_data:
				GlobalSceneLoader.load_battle_scene()
			else:
				GlobalSceneLoader.load_shop_scene()
	)

func upgrade_health(additional_points:int):
	if run_progress == null:
		return
	
	run_progress.character_data.health.max_value += additional_points

func upgrade_energy(additional_points:int):
	if run_progress == null:
		return
	
	run_progress.character_data.energy.max_value += additional_points

func upgrade_item_capacity():
	if run_progress == null:
		return
	
	run_progress.item_capacity += 1
	pass

func save_character_health(current_health:int):
	if run_progress == null:
		return
	
	run_progress.character_data.health = Stat.new(
		run_progress.character_data.health.max_value,
		0,
		current_health,
		false
	)

func add_gold(amount:int):
	if run_progress == null:
		return
	run_progress.gold += amount
	gold_updated.emit(get_gold())

func get_gold():
	if run_progress == null:
		return 0
	return run_progress.gold

func can_buy_item(item_price:int):
	if run_progress == null:
		return false
	
	if item_price <= run_progress.gold:
		if run_progress.heald_items.size() <= run_progress.item_capacity - 1:
			return true
	print("Not enough gold or inventory is full")
	return false

func buy_item(item:ItemData):
	if run_progress == null:
		return
	
	run_progress.gold -= item.shop_price
	run_progress.heald_items.append(item)
	gold_updated.emit(get_gold())
	pass


func can_sell_item(item:ItemData):
	if run_progress == null:
		return
	
	return run_progress.heald_items.has(item)

func sell_held_item(item:ItemData):
	if run_progress == null:
		return
	
	consume_item(item)
	add_gold(item.sell_price)

func consume_item(item:ItemData):
	if run_progress == null:
		return
	
	if run_progress.heald_items.has(item):
		run_progress.heald_items.erase(item)

func get_character_trait(target_trait:String):
	if run_progress == null:
		return
	
	var search_trait = target_trait.to_upper()
	match search_trait:
		"OFFENSIVE":
			return run_progress.character_data.offensive_trait
		"DEFENSIVE":
			return run_progress.character_data.defensive_trait
		"STRATEGIC":
			return run_progress.character_data.strategic_trait
	
	return null

func get_character():
	if run_progress == null:
		return null
	return run_progress.character_data

func get_heald_items():
	if run_progress == null:
		return [] as Array[ItemData]
	return run_progress.heald_items

func get_floor_progress():
	if run_progress == null:
		return -1
	return run_progress.floor_progress

func get_current_floor():
	if run_progress == null:
		return -1
	return run_progress.current_floor

func get_character_sprite():
	if run_progress == null:
		return null
	if run_progress.character_data == null:
		return load("res://Testing/donkey.tres")
	return run_progress.character_data.display_texture
