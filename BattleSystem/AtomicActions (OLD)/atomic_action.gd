@abstract

extends Resource
class_name AtomicAction
# Abstract template base resource for all qeuable and executable actions in 
# a battle.
#
# AtomicActions represent the smallest units of behavior that
# can be composed into a CombatMove, such as dealing damage,
# healing entities, modifying personality traits, spawning
# projectiles, or activating special abilities.
#
# Action context includes the action's user, targets, battlefield objects,
# and the player's cards.
#
# Intended to be used as a creatable asset within CombatMove
# parameter fields.

# TODO: When LLM Model is being implemented, create a dictionary that
# indexes every atomic action class so that it can create CombatMoves with
# atomic actions as building blocks

@abstract
func execute(action_context:ActionContext)
