@abstract
extends Action
class_name TargetedAction

enum TargetOption {SELF, PLAYER, ENEMY, ENEMIES}
@export var target_option:TargetOption

# Fletcher - This ignores objects in front of the player for
#            targeted skills like shrink.
@export var ignore_foreground: bool = false

var resolved_targets:Array[AbstractEntity]

const SINGLE_TARGET_DELAY = 0.4
const MULTI_TARGET_DELAY = 0.8

@abstract
func execute(_context:BattleContext = null, _user:AbstractEntity = null)


func action_resolve_delay():
	if resolved_targets.size() > 1:
		if is_instance_valid(resolved_targets[0]):
			await resolved_targets[0].get_tree().create_timer(MULTI_TARGET_DELAY).timeout
	else:
		if is_instance_valid(resolved_targets[0]):
			await resolved_targets[0].get_tree().create_timer(SINGLE_TARGET_DELAY).timeout
