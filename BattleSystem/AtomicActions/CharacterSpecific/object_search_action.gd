extends AtomicAction
class_name ObjectSearchAction
## AtomicAction responsible for moving the player behind objects in battles.
##
## Searches for a battle position in battle field that has a queried object
## in front of it. If the queried object is found, the number of steps to
## reach the object is calculated and the player entity moves towards it,
## yielding until the battlefield reports movement completion.

@export var search_for_object_type:BattleObjectData.Type

func execute(action_context:ActionContext):
	var steps:int = action_context.battle_field.get_player_distance_to_object(
			search_for_object_type
			)
	
	if steps == 0:
		# TODO: Determine if another instance of the queried object type exists
		# then move player entity towards it. Otherwise play an animation on the
		# player entity that shows they are confused
		print("already here!")
	if steps != -9:
		action_context.battle_field.move_player(steps)
		await action_context.battle_field.moved_position
