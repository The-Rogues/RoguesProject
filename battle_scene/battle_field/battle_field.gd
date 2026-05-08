extends Node2D
class_name BattleField
## Responsible for managing battle positions, placing objects, applying position
## effects, and communicating object events

signal object_placed(object:ObjectEntity)

## Battle positions the battle field manages. Set in inspector
@export var battle_positions:Array[BattlePosition]
signal object_interacted(interaction_actions:Array[Action], object:ObjectEntity)

var show_preferences: bool = false

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
		battle_positions[i].object_placed.connect(_on_object_placed)
		
		var object_data:ObjectData = layout[i]
		
		if object_data:
			place_object(object_data , battle_positions[i])
			#battle_positions[i].place_object(object_data)


func _on_object_placed(object:ObjectEntity):
	object_placed.emit(object)
	
	object.interacted.connect(
			func(_object:ObjectEntity):
					object_interacted.emit(_object.data.interaction_actions, 
							_object))


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
			if !pos.get_object():
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
	
	
	# Animate movement
	await player.move_to(new_position.global_position)
	
	# Enter new position
	new_position.on_player_entered(player)


func enter_turn(turn_count:int, player:PlayerEntity):
	for battle_position in battle_positions:
		battle_position.enter_turn(turn_count, player)


func decay_position_effects():
	for battle_position in battle_positions:
		battle_position.decay_effect()


func toggle_preferences():
	for i in range(0, battle_positions.size()):
		var curr_object: ObjectEntity = battle_positions[i].get_object()
		if curr_object != null:
			var change = !curr_object.object_stat_display.preference_container.visible
			curr_object.object_stat_display.preference_container.visible = change


func update_preferences(in_player: PlayerEntity):
	var display_order: Array[int] = in_player.data.personality.create_trait_order(
		in_player.offensive_trait.weight_value,
		in_player.defensive_trait.weight_value,
		in_player.strategic_trait.weight_value
	)
	var highlight_trait: int = get_highest_trait(in_player)
	if highlight_trait == -1:
		return
	for i in range(0, battle_positions.size()):
		var curr_object = battle_positions[i].get_object()
		if curr_object != null:
			curr_object.object_stat_display.preference_container.visible = show_preferences
			curr_object.object_stat_display.preference_container.clear_icons()
			for j in range(0, display_order.size()):
				var curr_trait: Trait
				match display_order[j]:
					0:
						curr_trait = in_player.offensive_trait
					1:
						curr_trait = in_player.defensive_trait
					2:
						curr_trait = in_player.strategic_trait
				if curr_object.data.targeting_categories.has(curr_trait.data.object_targeting_preference):
					var highlight_icon: = false
					if j == highlight_trait:
						highlight_icon = true
					curr_object.object_stat_display.preference_container.add_icon(
						curr_trait.data.display_texture,
						highlight_icon
					)

func get_highest_trait(in_player: PlayerEntity) -> int:
	var display_order: Array[int] = in_player.data.personality.create_trait_order(
		in_player.offensive_trait.weight_value,
		in_player.defensive_trait.weight_value,
		in_player.strategic_trait.weight_value
	)
	var ret_index: int = display_order.size()
	for i in range(0, battle_positions.size()):
		var curr_object = battle_positions[i].get_object()
		if curr_object != null:
			curr_object.object_stat_display.preference_container.visible = show_preferences
			curr_object.object_stat_display.preference_container.clear_icons()
			for j in range(0, display_order.size()):
				var curr_trait: Trait
				match display_order[j]:
					0:
						curr_trait = in_player.offensive_trait
					1:
						curr_trait = in_player.defensive_trait
					2:
						curr_trait = in_player.strategic_trait
				if curr_object.data.targeting_categories.has(curr_trait.data.object_targeting_preference):
					if j < ret_index:
						ret_index = j
	if ret_index < display_order.size():
		return display_order[ret_index]
	return -1
