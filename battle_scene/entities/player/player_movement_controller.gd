extends Node
class_name PlayerMovementController

signal entered_new_position


var player: PlayerEntity
var battle_field: BattleField
var can_move:bool = true

#func move_by_offset(offset: int) -> void:
	#if !battle_field or !player:
		#return
	#
	#var positions = battle_field.battle_positions
	#var current = player.battle_position
	#
	#var index = positions.find(current)
	#if index == -1:
		#entered_new_position.emit()
		#return
	#
	#var last_index = positions.size() - 1
	#var new_index = index + offset
	#
	## If moving right from the rightmost, go left instead
	#if index == last_index and offset > 0:
		#new_index = index - 1
	#
	## If moving left from the leftmost, go right instead
	#elif index == 0 and offset < 0:
		#new_index = index + 1
	#
	#
	#if new_index == index:
		#return
	#
	#var target = positions[new_index]
	#await battle_field.move_player(player, target)
	#entered_new_position.emit()
#
#
#func move_left() -> void:
	#move_by_offset(-1)
#
#
#func move_right() -> void:
	#move_by_offset(1)
#
#
#func find_nearest_object_position_by_role(
	#role: ObjectData.Role
#) -> BattlePosition:
	#if !battle_field:
		#return null
	#
	#var positions = battle_field.battle_positions
	#var current = player.battle_position
	#
	#var current_index = positions.find(current)
	#if current_index == -1:
		#return null
	#
	#var closest_position: BattlePosition = null
	#var closest_distance := INF
	#
	#for i in range(positions.size()):
		#var pos:BattlePosition = positions[i]
		#var obj = pos.get_object()
		#
		#if obj and obj.data.role == role:
			#var distance = abs(current_index - i)
			#
			#if distance < closest_distance:
				#closest_distance = distance
				#closest_position = pos
	#
	#return closest_position
#
#
#func move_towards_nearest_object_position_by_role(
	#role: ObjectData.Role
#) -> void:
	#if !battle_field:
		#return
	#
	#var nearest_object_position := find_nearest_object_position_by_role(role)
	#var positions := battle_field.battle_positions
	#
	#if !nearest_object_position:
		#return
	#
	#var destination_index:int = positions.find(
		#nearest_object_position
	#)
	#
	#var current = player.battle_position
	#var current_index = positions.find(current)
	#
	#if destination_index > current_index:
		#move_right()
	#elif destination_index < current_index:
		#move_left()
	#else:
		#move_left()
#
#
#func move_toward_desired_object() -> void:
	#if !battle_field:
		#return
	#
	#pass

func move_out_of_cover() -> void:
	
	var empty_positions: Array[BattlePosition]
	for i in range(0, battle_field.battle_positions.size()):
		if battle_field.battle_positions[i].get_object() == null:
			if battle_field.battle_positions[i] != player.battle_position:
				empty_positions.append(battle_field.battle_positions[i])
	
	if empty_positions.size() == 0:
		return
	
	await battle_field.move_player(
		player, 
		empty_positions.pick_random()
	)
	entered_new_position.emit()

func position_state_updated():
	if player.battle_position.has_effect():
		player.battle_position.get_effect().on_player_entered(player)


func find_decoy_position() -> BattlePosition:
	for i in range(0, battle_field.battle_positions.size()):
		if battle_field.battle_positions[i].get_object() != null:
			if battle_field.battle_positions[i].get_object().data.targeting_categories.has(
				ObjectData.MoveTargetingCategory.DECOY
			):
				return battle_field.battle_positions[i]
	return null


func move_behind_perferred_object() -> void:
	if can_move == false: return
	
	var curr_objects: Array[ObjectEntity] = get_battle_field_objects()
	if curr_objects.size() < 1:
		return
	
	var target_object: ObjectEntity = player.data.personality.choose_object_target(
		curr_objects,
		player.offensive_trait.weight_value,
		player.defensive_trait.weight_value,
		player.strategic_trait.weight_value
	)
	
	await battle_field.move_player(
		player, 
		get_battle_position_by_object(
			target_object
		)
	)
	entered_new_position.emit()


func move_behind_object_type(in_type: ObjectData.MoveTargetingCategory) -> void:
	if can_move == false: return
	
	var eligible_objects: Array[ObjectEntity]
	var all_objects: Array[ObjectEntity] = get_battle_field_objects()
	
	for i in range(0, all_objects.size()):
		if all_objects[i].data.targeting_categories.has(in_type):
			eligible_objects.append(all_objects[i])
	
	if eligible_objects.size() < 1:
		return
	
	await battle_field.move_player(
		player, 
		get_battle_position_by_object(
			eligible_objects.pick_random()
		)
	)
	entered_new_position.emit()


func move_toward_perfered_object(num_spaces: int) -> void:
	if can_move == false: return
	num_spaces = clamp(num_spaces, 1, 4)
	
	var player_index = battle_field.battle_positions.find(
		player.battle_position
	)
	
	if player_index == 0:
		move_player_right(num_spaces)
		return
	elif player_index == 4:
		move_player_left(num_spaces)
		return
	
	var valid_positions: Array[BattlePosition] = battle_field.battle_positions.duplicate(true)
	for i in range(0, valid_positions.size()):
		if valid_positions[i] == player.battle_position:
			valid_positions[i] = BattlePosition.new()
	var is_right: bool = player.data.personality.choose_move_direction(
		clamp(player_index - num_spaces, 0, 4),
		clamp(player_index + num_spaces, 0, 4),
		valid_positions,
		player.offensive_trait.weight_value,
		player.defensive_trait.weight_value,
		player.strategic_trait.weight_value
	)
	
	if is_right:
		move_player_right(num_spaces)
		return
	move_player_left(num_spaces)


func move_player_left(num_spaces: int) -> void:
	if can_move == false: return
	var player_index = battle_field.battle_positions.find(
		player.battle_position
	)
	
	if player_index == 0:
		return
	
	await battle_field.move_player(
		player, 
		battle_field.battle_positions[
			clamp(player_index - num_spaces, 0, 4)
		]
	)
	entered_new_position.emit()


func move_player_right(num_spaces: int) -> void:
	if can_move == false: return
	var player_index = battle_field.battle_positions.find(
		player.battle_position
	)
	
	if player_index == 4:
		return
	
	await battle_field.move_player(
		player, 
		battle_field.battle_positions[
			clamp(player_index + num_spaces, 0, 4)
		]
	)
	entered_new_position.emit()


func get_battle_position_by_object(in_object: ObjectEntity) -> BattlePosition:
	for i in range(0, battle_field.battle_positions.size()):
		if in_object == battle_field.battle_positions[i].get_object():
			return battle_field.battle_positions[i]
	return null


func get_battle_field_objects() -> Array[ObjectEntity]:
	var ret_val: Array[ObjectEntity]
	for i in range(0, battle_field.battle_positions.size()):
		if battle_field.battle_positions[i].get_object() != null && battle_field.battle_positions[i].get_object().health.value != 0:
			if player.battle_position != battle_field.battle_positions[i]:
				ret_val.append(battle_field.battle_positions[i].get_object())
	return ret_val
