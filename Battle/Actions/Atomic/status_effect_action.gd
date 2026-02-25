extends TargetedBattleAction
class_name StatusEffectAction

enum OperationType { ADD, REMOVE, CLEAR }

@export var operation:OperationType
@export var status:StatusEffectData
@export var duration:int = 1
@export var stacks:int = 1
@export_range(0.0, 1.0) var chance:float = 1.0

func _execute(battle_instance:BattleManager, _action_user:BattleEntity = null):
	targeting = _resolve_target(battle_instance, _action_user)
	
	if operation == OperationType.ADD:
		for target in targeting:
			if randf() > chance:
				continue
			
			if status:
				target.status_conditions.add_status(
						status,
						duration,
						stacks
				)
	elif operation == OperationType.REMOVE:
		for target in targeting:
			if randf() > chance:
				continue
			
			target.status_conditions.find_and_remove_status(status.id)
	elif operation == OperationType.CLEAR:
		for target in targeting:
			target.status_conditions.clear_status_effects()
