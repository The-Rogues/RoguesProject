extends AtomicAction
class_name ConditionalObjectSearchAction

@export var object_type:BattleObjectData.Type
@export var conditional_action:AtomicAction

func execute(battle_info:BattleActionInfo):
	var steps:int = battle_info.battle_field.get_player_distance_to_object(object_type)
	
	if steps == 0:
		battle_info.action_queue.enqueue(conditional_action, battle_info)
	if steps != -9:
		battle_info.battle_field.move_player(steps)
		await battle_info.battle_field.moved_position
		battle_info.action_queue.enqueue(conditional_action, battle_info)
