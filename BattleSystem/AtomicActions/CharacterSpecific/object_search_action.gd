# ==========================================================
# Author: Fabian 
# Description:
#   An editable resource that performs an operation that makes 
#   the player character move behind a battle object in BattleField
#   if one exists of a passed type.
#   To be used as a creatable asset in paramater fields of CombatMove.
#
# ==========================================================

extends AtomicAction
class_name ObjectSearchAction

@export var object_type:BattleObjectData.Type

func execute(action_context:ActionContext):
	var steps:int = action_context.battle_field.get_player_distance_to_object(object_type)
	if steps == 0:
		# TODO: Replace with animation or find the next object
		print("already here!")
	if steps != -9:
		action_context.battle_field.move_player(steps)
		await action_context.battle_field.moved_position
