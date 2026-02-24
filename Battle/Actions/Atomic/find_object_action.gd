extends BattleAction
class_name FindObjectAction

@export var object_id:String
@export var conditional_action:BattleAction
@export var consequential_action:BattleAction

func _execute(battle_instance:BattleManager, action_user:BattleEntity):
	var object_position:BattlePosition = battle_instance.battle_field.find_object(object_id)
	
	if object_position:
		battle_instance.battle_field.move_entity(object_position)
		await battle_instance.battle_field.entity_arrived
		
		if conditional_action:
			battle_instance.action_queue.enqueue(
				conditional_action,
				battle_instance,
				action_user
			)
	else:
		if consequential_action:
			battle_instance.action_queue.enqueue(
				consequential_action,
				battle_instance,
				action_user
			)
