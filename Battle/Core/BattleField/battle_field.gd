extends Node2D
class_name BattleField

signal entity_arrived

@export var battle_positions:Array[BattlePosition]
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
		old_position.on_entity_exited(player)
	
	# Update state FIRST (important)
	player.battle_position = new_position
	
	# Enter new position
	new_position.on_entity_entered(player)
	
	# Animate movement
	await player.move_to(new_position.global_position)


func on_new_turn_started():
	for pos in battle_positions:
		pos.start_turn()
