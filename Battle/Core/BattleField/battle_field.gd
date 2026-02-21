extends Node2D
class_name BattleField

signal moved_position

var player_entity:BattleEntity
@export var battle_object_offset:Vector2
@export_range(0, 1) var opportunity_chance:float = 1
@export_range(0, 5) var max_opportunities:int = 2

var battle_positions:Array[BattlePosition]
var object_layout:Array[ObjectEntity]
var opportunities:Array[BattlePosition]

var current_player_position:int = 2
var last_player_position:int = 2
var player_on_opportunity:bool = false

const OBJECT_TEMPLATE = preload("res://Entities/Scenes/object_entity.tscn")


func initialize(battle_object_layout:BattleObjectLayout, player:BattleEntity):
	# Get and store all battle positions
	for child in get_children():
		if child is BattlePosition:
			battle_positions.append(child)
	
	player_entity = player
	var new_battle_object_layout = battle_object_layout.layout
	
	for i in range(0, new_battle_object_layout.size()):
		var battle_position = battle_positions[i]
		var new_object:ObjectEntity = OBJECT_TEMPLATE.instantiate()
		
		if new_battle_object_layout[i] != null:
			battle_position.add_child(new_object)
			new_object.initialize(new_battle_object_layout[i])
			new_object.position += battle_object_offset
			object_layout.append(new_object)
			new_object.defeated.connect(_on_object_destroyed)
		else:
			object_layout.append(null)

func initialize_player(player:BattleEntity):
	if battle_positions.is_empty():
		return
	
	current_player_position = 2
	player.move_to(battle_positions[2].global_position)

func get_player():
	return player_entity

func on_new_turn_started():
	for opportunity in opportunities:
		opportunity.decay()
		
		if opportunity.life_span == 0:
			opportunities.erase(opportunity)
	
	if randf() <= opportunity_chance and opportunities.size() < max_opportunities:
		create_opportunity()
	
	check_if_player_on_opportunity()

func create_opportunity():
	var random_battle_position = battle_positions.pick_random()
	var random_opportunity = randi_range(1, BattlePosition.Opportunity.size())
	random_battle_position.set_opportunity(random_opportunity)
	opportunities.append(random_battle_position)

func check_if_player_on_opportunity():
	if battle_positions[current_player_position].has_opportunity() and !player_on_opportunity:
		on_player_entered_opportunity(battle_positions[current_player_position])
	if !battle_positions[current_player_position].has_opportunity() and player_on_opportunity:
		on_player_exited_opportunity(battle_positions[last_player_position])

func move_player(move_count:int):
	if !player_entity:
		return
	
	var new_position:int = current_player_position + move_count
	
	
	if new_position < 0:
		new_position = 0
	elif new_position >= battle_positions.size():
		new_position = battle_positions.size() - 1
		
	await player_entity.move_to(battle_positions[new_position].global_position)
	current_player_position = new_position
	moved_position.emit()
	
	check_if_player_on_opportunity()
	last_player_position = current_player_position

func on_player_entered_opportunity(battle_position:BattlePosition):
	if !player_entity:
		return
	
	if !battle_position.has_opportunity():
		player_on_opportunity = false
		return
	
	match battle_position.opportunity:
		BattlePosition.Opportunity.DEFENSE:
			player_entity.status_conditions.add_status(ProtectedStatusEffect.new(), 1, 2)
		BattlePosition.Opportunity.OFFENSE:
			player_entity.status_conditions.add_status(StrengthStatusEffect.new(), 1, 2)
	
	player_on_opportunity = true

func on_player_exited_opportunity(battle_position:BattlePosition):
	if !player_entity:
		return
	
	player_on_opportunity = false 

func _on_object_destroyed(object:ObjectEntity):
	var obj_index = object_layout.find(object)
	if obj_index != -1:
		object_layout[obj_index] = null


func get_nearest_object_direction(object_type:int):
	var distances:Array[int]
	var dir:int = 1
	for position in object_layout.size():
		if object_layout[position]:
			if object_layout[position].data.object_type == object_type:
				distances.append(current_player_position - position)
	if distances.is_empty():
		var rand = randf()
		
		if rand < 0.5:
			dir *= -1
		return dir
	
	var min = distances.min()
	if min == 0:
		print("already at min")
		var rand = randf()
		if rand < 0.5:
			dir *= -1
		return dir
	print("find")
	return -min


func get_player_distance_to_object(object_type:ObjectEntityData.Type):
	for i in range(0, object_layout.size()):
		if !object_layout[i]:
			if object_type == ObjectEntityData.Type.NONE:
				return i - current_player_position
			continue
		if object_layout[i].data.object_type == object_type:
			print("found object")
			return i - current_player_position
	# ERROR CODE
	return -9

func get_object_infront_of_player():
	return object_layout[current_player_position]
