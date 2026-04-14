extends RefCounted
class_name QueuedAction
# The action to be performed (damage, heal, move, add card)
var action: Action
var user: AbstractEntity
var context: BattleContext
# Constructor
func _init(
		_action: Action, 
		_context: BattleContext,
		_user: AbstractEntity
	):
	action = _action
	user = _user
	context = _context

func execute() -> void:
	await action.execute(context, user)
