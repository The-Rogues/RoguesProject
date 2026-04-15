extends Node2D
class_name BattleField
## Responsible for managing battle positions, placing objects, applying position
## effects, and communicating object events

## Battle positions the battle field manages. Set in inspector
@export var battle_positions:Array[BattlePosition]
signal object_interacted(interaction_actions:Array[Action], object:ObjectEntity)


## Called to place objects at the start of battle
func setup_objects(config:BattleFieldConfig):
	if battle_positions.is_empty():
		printerr("No battle positions references in BattleFieldHandler")
		return
	
	var layout:Array[ObjectData] = config.get_layout_as_array()
	
	if layout.size() != battle_positions.size():
		printerr("Object layout size doesn't match available battle positions")
		return
	
	# If data is null in an index, there is no object
	# If data is not null, the indexed position has an object to place
	for i in range(0, battle_positions.size()):
		var object_data:ObjectData = layout[i]
		
		if object_data:
			place_object(object_data , battle_positions[i])
			#battle_positions[i].place_object(object_data)
		
		battle_positions[i].object_placed.connect(_on_object_placed)


func _on_object_placed(object:ObjectEntity):
	object.interacted.connect(func(_object:ObjectEntity):
			object_interacted.emit(_object.data.interaction_actions, _object))



## Attempts to place object in a battle position. If battle_position is null,
## will try to place object in the first open position. If no open positions exist
## returns false
func place_object(
	object:ObjectData, 
	battle_position:BattlePosition = null
) -> bool:
	var target_position:BattlePosition = null
	
	# Assign if battle position is part of recognized positions
	if battle_positions.has(battle_position):
		target_position = battle_position
	else:
		# Find next random position
		for pos in battle_positions:
			if !pos.object:
				target_position = pos
				break
	
	# No available positions
	if !target_position:
		return false
	
	target_position.place_object(object)
	
	return true


func move_player(
	player: PlayerEntity, 
	new_position: BattlePosition
):
	if not player or not new_position:
		return
	
	if player.is_moving:
		return
	
	var old_position = player.battle_position
	
	# Exit old position
	if old_position:
		old_position.on_player_exited(player)
	
	# Update state FIRST (important)
	player.battle_position = new_position
	
	# Enter new position
	new_position.on_player_entered(player)
	
	# Animate movement
	await player.move_to(new_position.global_position)


func enter_turn(turn_count:int):
	for battle_position in battle_positions:
		battle_position.enter_turn(turn_count)
