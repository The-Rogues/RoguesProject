# ==========================================================
# Author: Fabian 
# Description:
#   An editable resource that executes a passed AtomicAction.
#   on the condition that an object in the battle field is
#   found and moved to first.
#   Ex. Find cover, if found: move behind it, then heal
#   To be used as a creatable asset in paramater fields of CombatMove.
#
# ==========================================================

extends AtomicAction
class_name ConditionalObjectSearchAction

@export var object_type:BattleObjectData.Type
@export var conditional_action:AtomicAction

func execute(action_context:ActionContext):
	# Gets the distance from the character's current position in BattleField
	# and a queried object type. Returns -9 if none found
	var steps:int = action_context.battle_field.get_player_distance_to_object(
				object_type)
	# Already behind object
	# TODO: Edit get_player_distance function to prioritize new instances
	# of a type of object. If another object can not be found, then run this
	# as a fallback
	if steps == 0:
		action_context.action_queue.enqueue(conditional_action, action_context)
	# Found object
	if steps != -9:
		# Wait until character finishes moving behind found object
		action_context.battle_field.move_player(steps)
		await action_context.battle_field.moved_position
		# Then enque action
		action_context.action_queue.enqueue(conditional_action, action_context)
