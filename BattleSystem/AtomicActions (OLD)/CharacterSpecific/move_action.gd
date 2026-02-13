extends AtomicAction
class_name MoveAction
## AtomicAction responsible for horizontal player movement in battle.
##
## Executes lane-to-lane movement for the player entity based on a fixed
## or random direction and a step count, yielding until the battlefield
## reports movement completion.

# Enum used for directions to improve readability
enum DIRECTION {LEFT, RIGHT, RANDOM}
## Controls direction that player will try to move horizontally
@export var direction:DIRECTION
## Controls number of spaces the player will move in a specified
## direction
@export_range(1, 4) var steps:int = 1

# TODO: In this action, targeting information from battle context is redundant
#   as player character is currently the only entity that moves. Consider
#   refactoring
# TODO: Consider the role of LEFT or RIGHT movements vs Random. It can be
#   useful having a card that always moves LEFT but what should it do when
#   when the last position is reached?

func execute(action_context:ActionContext):
	var dir:int = steps
	if direction == DIRECTION.LEFT:
		dir = -dir
	elif direction == DIRECTION.RIGHT:
		pass
	elif direction == DIRECTION.RANDOM:
		var rand = randf()
		
		if rand < 0.5:
			dir *= -1
	
	action_context.battle_field.move_player(dir)
	await action_context.battle_field.moved_position
