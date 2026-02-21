extends TargetedBattleAction
class_name StatusEffectAction

enum OperationType {ADD_STATUS, REMOVE_STATUS}
@export var operation:OperationType
@export var status_effect:StatusEffectData
@export var status_duration:int
@export var stack_count:int
@export_range(0,1) var status_chance:float = 1.0

func _execute(battle_instance:BattleManager, action_user:BattleEntity):
	targeting = _resolve_target(battle_instance, action_user)
	
	if operation == OperationType.ADD_STATUS:
		for target in targeting:
			if randf() > status_chance:
				continue
			
			target.status_conditions.add_status(
					status_effect,
					status_duration,
					stack_count
			)
	elif operation == OperationType.REMOVE_STATUS:
		for target in targeting:
			if randf() > status_chance:
				continue
			
			target.status_conditions.find_and_remove_status(status_effect.id)
