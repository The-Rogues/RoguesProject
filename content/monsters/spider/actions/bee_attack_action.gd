extends AttackAction
class_name BeeAttackAction

@export var unblocked_action: Action

func execute(_context:BattleContext = null, _user:AbstractEntity = null):
	var is_player: bool = false
	var start_HP: int
	if resolved_targets[0] is PlayerEntity && resolved_targets.size() == 1:
		is_player = true
		start_HP = resolved_targets[0].health.value
	
	hits = 1
	await super(_context, _user)
	
	if is_player:
		if is_instance_valid(resolved_targets[0]) && start_HP > resolved_targets[0].health.value:
			await unblocked_action.execute(_context, _user)
