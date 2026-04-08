extends Node
class_name PlayerMovementController

var player: PlayerEntity
var battle_field: BattleField


func move_by_offset(offset: int) -> void:
	if !battle_field or !player:
		return
	
	var positions = battle_field.battle_positions
	var current = player.battle_position
	
	var index = positions.find(current)
	if index == -1:
		return
	
	var new_index = clamp(index + offset, 0, positions.size() - 1)
	if new_index == index:
		return
	
	var target = positions[new_index]
	await battle_field.move_player(player, target)


func move_left() -> void:
	move_by_offset(-1)


func move_right() -> void:
	move_by_offset(1)


func find_nearest_object_position_by_role(
	role: ObjectData.Role
) -> BattlePosition:
	if !battle_field:
		return null
	
	var positions = battle_field.battle_positions
	var current = player.battle_position
	
	var current_index = positions.find(current)
	if current_index == -1:
		return null
	
	var closest_position: BattlePosition = null
	var closest_distance := INF
	
	for i in range(positions.size()):
		var pos = positions[i]
		var obj = pos.get_object()
		
		if obj and obj.role == role:
			var distance = abs(current_index - i)
			
			if distance < closest_distance:
				closest_distance = distance
				closest_position = pos
	
	return closest_position


func move_towards_nearest_object_position_by_role(
	role: ObjectData.Role
) -> void:
	if !battle_field:
		return
	
	var nearest_object_position := find_nearest_object_position_by_role(role)
	var positions := battle_field.battle_positions
	
	if !nearest_object_position:
		return
	
	var destination_index:int = positions.find(
		nearest_object_position
	)
	
	var current = player.battle_position
	var current_index = positions.find(current)
	
	if destination_index > current_index:
		move_right()
	elif destination_index < current_index:
		move_left()
	else:
		move_left()


func move_toward_desired_object() -> void:
	if !battle_field:
		return
	
	pass
