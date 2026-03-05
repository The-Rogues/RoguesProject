extends Node2D
class_name BattleField

signal entity_arrived

@export var battle_positions:Array[BattlePosition]
var entity:BattleEntity
var entity_position:int = 2
var last_player_position:int = 2


func initialize(object_layout:BattleObjectLayout, battle_entity:BattleEntity):
	if battle_positions.is_empty():
		return
	
	# Assumes there are equal amount of battle positions to layout
	for i in range(0, object_layout.layout.size()):
		battle_positions[i].set_object(object_layout.layout[i])
	
	entity_position = round(battle_positions.size() / 2)
	entity = battle_entity
	
	move_entity(battle_positions[entity_position])


func move_entity(target_position:BattlePosition) -> void:
	if not entity:
		return
	
	var position_index = battle_positions.find(target_position)
	if position_index == -1:
		return
	
	entity.move_to(target_position.global_position)
	battle_positions[entity_position].on_entity_exited(entity)
	await entity.arrived
	target_position.on_entity_entered(entity)
	entity_position = battle_positions.find(target_position)
	entity_arrived.emit()


func move_entity_left():
	if not entity:
		return null
	var destination:int = 0
	if entity_position == 0:
		destination = entity_position + 1
	else:
		destination = entity_position - 1
	
	move_entity(battle_positions[destination])


func move_entity_right():
	if not entity:
		return null
	
	var destination:int = 0
	if entity_position == battle_positions.size()-1:
		destination = entity_position - 1
	else:
		destination = entity_position + 1
	
	move_entity(battle_positions[destination])

## Returns battle positions with a object matching object id
func find_objects(object_id:String) -> Array[BattlePosition]:
	var objects:Array[BattlePosition]
	for i in range(0, battle_positions.size()):
		if !battle_positions[i].object:
			continue
		
		if battle_positions[i].object.data.id == object_id:
			objects.append(battle_positions[i])
	return objects

## Returns the closest position matching an object id
func find_object(object_id:String) -> BattlePosition:
	var positions:Array[BattlePosition] = find_objects(object_id)
	if positions.is_empty():
		return null
	
	var closest_position_index = battle_positions.find(positions[0])
	var closest_distance:int = abs(entity_position - closest_position_index)
	
	for i in range(1, positions.size() - 1):
		var position_index = battle_positions.find(positions[i])
		var distance = abs(entity_position - position_index)
		
		if closest_distance > distance:
			closest_distance = distance
			closest_position_index = position_index
	
	return positions[closest_position_index]


func get_direction_to_object(object_id:String):
	if not entity:
		return 0
	
	var object = find_object(object_id)
	if not object:
		return 0
	var object_index = battle_positions.find(object)
	if object_index > entity_position:
		return 1
	else:
		return -1

## Returns object in current entity position
func get_object() -> ObjectEntity:
	if not entity:
		return null
	return battle_positions[entity_position].object


func get_current_position() -> BattlePosition:
	if not entity:
		return null
	
	return battle_positions[entity_position]


func on_new_turn_started():
	for pos in battle_positions:
		pos.start_turn()
