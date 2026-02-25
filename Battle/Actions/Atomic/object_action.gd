extends BattleAction
class_name ObjectAction

enum ActionType {SEARCH, CHECK, CREATE}
@export var action_type:ActionType
@export_group("Search Options")
@export var search_object_id:String
@export var move_to_object:bool = true
@export var on_found_action:BattleAction
@export var on_not_found_action:BattleAction
@export_group("Check Options")
@export var repair_object:int = -1
@export_group("Create Options")
@export var create_object:ObjectEntityData


func _execute(battle_instance:BattleManager, _action_user:BattleEntity = null):
	match action_type:
		ActionType.SEARCH:
			var object_position:BattlePosition = battle_instance.battle_field.find_object(
				search_object_id
			)
			
			if move_to_object:
				battle_instance.battle_field.move_entity(object_position)
				await battle_instance.battle_field.entity_arrived
			
			queue_actions(
					object_position != null, 
					battle_instance, 
					_action_user
			)
		ActionType.CHECK:
			var object = battle_instance.battle_field.get_object()
			
			if object and repair_object != -1:
				object.heal(repair_object)
			
			queue_actions(
					object.data.id == search_object_id, 
					battle_instance, 
					_action_user
			)
		ActionType.CREATE:
			battle_instance.player_entity.carry_object(create_object)
			var pos:BattlePosition = battle_instance.battle_field.battle_positions[
				battle_instance.battle_field.entity_position
			]
			pos.on_entity_entered(battle_instance.player_entity)
	pass


func queue_actions(
		condition_satisfied:bool, 
		battle_instance:BattleManager, 
		action_user:BattleEntity
):
	if condition_satisfied:
		if on_found_action:
			battle_instance.action_queue.enqueue(
				on_found_action,
				battle_instance,
				action_user
			)
		elif on_not_found_action:
				battle_instance.action_queue.enqueue(
				on_not_found_action,
				battle_instance,
				action_user
			)
