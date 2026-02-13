extends Node2D
class_name BattleField

signal moved_position

@export var player_entity:BattleEntity
@export var battle_object_offset:Vector2
@export_range(0, 1) var opportunity_chance:float = 1
@export_range(0, 5) var max_opportunities:int = 2

var battle_positions:Array[BattlePosition]
var battle_object_positions:Array[BattleFieldObject]
var opportunities:Array[BattlePosition]

var current_player_position:int = 2
var last_player_position:int = 2
var player_on_opportunity:bool = false

const OBJECT_TEMPLATE = preload("res://BattleSystem/Entities/Objects/battle_object_template.tscn")

func initialize(battle_object_layout:BattleObjectLayout):
	# Get and store all battle positions
	for child in get_children():
		if child is BattlePosition:
			battle_positions.append(child)
	
	var new_battle_object_layout = battle_object_layout.layout
	
	for i in range(0, new_battle_object_layout.size()):
		var battle_position = battle_positions[i]
		var new_object:BattleFieldObject = OBJECT_TEMPLATE.instantiate()
		
		if new_battle_object_layout[i] != null:
			battle_position.add_child(new_object)
			new_object.initialize(new_battle_object_layout[i])
			new_object.position += battle_object_offset
			battle_object_positions.append(new_object)
			new_object.defeated.connect(_on_object_destroyed)
		else:
			battle_object_positions.append(null)

func initialize_player(player:BattleEntity):
	player_entity = player
	if battle_positions.is_empty():
		return
	
	current_player_position = 2
	player.move_to(battle_positions[2].global_position)

func get_player():
	return player_entity

func on_new_turn_started():
	if battle_positions.is_empty():
		return
	for opportunity in opportunities:
		opportunity.decay()
		
		if opportunity.life_span == 0:
			opportunities.erase(opportunity)
	
	if randf() <= opportunity_chance and opportunities.size() < max_opportunities:
		create_opportunity()
	
	check_if_player_on_opportunity()

func create_opportunity():
	if battle_positions.is_empty():
		return

	var random_battle_position : BattlePosition= battle_positions.pick_random()
	if random_battle_position == null:
		return

	var random_opportunity := randi_range(1, BattlePosition.Opportunity.size())
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
			player_entity.entity_data.defense_amplifier.increase(0.5)
		BattlePosition.Opportunity.OFFENSE:
			player_entity.entity_data.attack_amplifier.increase(0.5)
	
	player_on_opportunity = true

func on_player_exited_opportunity(battle_position:BattlePosition):
	if !player_entity:
		return
	
	match battle_position.opportunity:
		BattlePosition.Opportunity.DEFENSE:
			player_entity.entity_data.defense_amplifier.reduce(0.5)
		BattlePosition.Opportunity.OFFENSE:
			player_entity.entity_data.attack_amplifier.reduce(0.5)
	
	player_on_opportunity = false 

func _on_object_destroyed(object:BattleFieldObject):
	var obj_index = battle_object_positions.find(object)
	if obj_index != -1:
		battle_object_positions[obj_index] = null
	
	#object.queue_free()

func get_player_distance_to_object(object_type:BattleObjectData.Type):
	for i in range(0, battle_object_positions.size()):
		if !battle_object_positions[i]:
			continue
		if battle_object_positions[i].entity_data.object_type == object_type:
			print("found object")
			return i - current_player_position
	# ERROR CODE
	return -9

func get_object_infront_of_player():
	return battle_object_positions[current_player_position]
