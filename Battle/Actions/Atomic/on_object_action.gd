extends BattleAction
class_name OnObjectAction

@export var object_id:String
@export var conditional_action:BattleAction
@export var consequential_action:BattleAction

func _execute(battle_instance:BattleManager, action_user:BattleEntity):
	var object = battle_instance.battle_field.get_object()
	if object.data.id == object_id:
		if conditional_action:
			battle_instance.action_queue.enqueue(
				conditional_action,
				battle_instance,
				action_user
			)
	else:
		if conditional_action:
			battle_instance.action_queue.enqueue(
				consequential_action,
				battle_instance,
				action_user
			)
