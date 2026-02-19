extends BattleAction
class_name PlayerObjectSearchAction

enum ObjectType {OPEN, COVER, TREASURE, WEAPON}
@export var object_type:ObjectEntityData.Type
@export var conditional_action:BattleAction

func _execute(battle_instance:BattleManager, action_user:BattleEntity):
	var steps:int = \
			battle_instance.battle_field.get_player_distance_to_object(
				object_type
			)
	
	if steps == 0:
		if not conditional_action:
			return
		battle_instance.action_queue.enqueue(
				conditional_action,
				battle_instance,
				action_user
		)
	# Found object
	if steps != -9:
		# Wait until character finishes moving behind found object
		battle_instance.battle_field.move_player(steps)
		await battle_instance.battle_field.moved_position
		
		if not conditional_action:
			return
		# Then enque action
		battle_instance.action_queue.enqueue(
				conditional_action,
				battle_instance,
				action_user
		)
