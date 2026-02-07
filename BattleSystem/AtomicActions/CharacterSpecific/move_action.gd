# ==========================================================
# Author: Fabian 
# Description:
#   An editable resource that performs an operation that makes 
#   the player character move to an adjacent battle position.
#   To be used as a creatable asset in paramater fields of CombatMove.
#
# ==========================================================

extends AtomicAction
class_name MoveAction

enum DIRECTION {Left, Right, Random}
@export_range(1, 4) var steps:int = 1
@export var direction:DIRECTION

# TODO: In this action, targeting information from battle context is redundant
#   as player character is currently the only entity that moves. Consider
#   refactoring
# TODO: Consider the role of Left or Right movements vs Random. It can be
#   useful having a card that always moves left but what should it do when
#   when the last position is reached?

func execute(action_context:ActionContext):
	var dir:int = steps
	if direction == DIRECTION.Left:
		dir = -dir
	elif direction == DIRECTION.Right:
		pass
	elif direction == DIRECTION.Random:
		var rand = randf()
		
		if rand < 0.5:
			dir *= -1
	
	action_context.battle_field.move_player(dir)
	await action_context.battle_field.moved_position
