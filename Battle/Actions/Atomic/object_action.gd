extends BattleAction
class_name ObjectAction

enum ActionType { CREATE, DESTROY }

@export var action_type:ActionType
@export var object_data:ObjectEntityData

func _execute(battle_instance:BattleManager, _action_user:BattleEntity = null):
	match action_type:
		ActionType.CREATE:
			battle_instance.player_entity.carry_object(object_data)
			var pos:BattlePosition = battle_instance.battle_field.get_current_position()
			pos.on_entity_entered(battle_instance.player_entity)
		ActionType.DESTROY:
			var object:ObjectEntity = battle_instance.battle_field.get_object()
			if object:
				object.queue_free()
