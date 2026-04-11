@abstract
extends Action
class_name TargetedAction

enum TargetOption {SELF, PLAYER, ENEMY, ENEMIES}
@export var target_option:TargetOption

var resolved_targets:Array[AbstractEntity]

const SINGLE_TARGET_DELAY = 0.4
const MULTI_TARGET_DELAY = 0.8

@abstract
func execute(_context:BattleContext = null, _user:AbstractEntity = null)


func action_resolve_delay():
	if resolved_targets.size() > 1:
		await resolved_targets[0].get_tree().create_timer(MULTI_TARGET_DELAY).timeout
	else:
		await resolved_targets[0].get_tree().create_timer(SINGLE_TARGET_DELAY).timeout
