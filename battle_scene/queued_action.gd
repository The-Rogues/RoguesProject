extends RefCounted
class_name QueuedAction
# The action to be performed (damage, heal, move, add card)
var action: Action
var user: AbstractEntity
var context: BattleContext
var recalculate_targeting: bool
# Constructor
func _init(
		_action: Action, 
		_context: BattleContext,
		_user: AbstractEntity,
		_recalculate: bool = false
	):
	action = _action
	user = _user
	context = _context
	recalculate_targeting = _recalculate

func execute() -> void:
	if user != null and not is_instance_valid(user):
		user = null
	await action.execute(context, user)
