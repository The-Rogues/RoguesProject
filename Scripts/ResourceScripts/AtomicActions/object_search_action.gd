extends AtomicAction
class_name ObjectSearchAction

@export var object_type:BattleObjectData.Type

func execute(battle_info:BattleActionInfo):
	var steps:int = battle_info.battle_field.get_player_distance_to_object(object_type)
	if steps == 0:
		# TODO: Replace with animation or find the next object
		print("already here!")
	if steps != -9:
		battle_info.battle_field.move_player(steps)
		await battle_info.battle_field.moved_position
