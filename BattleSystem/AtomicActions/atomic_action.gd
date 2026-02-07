# ==========================================================
# Author: Fabian 
# Description:
#   A template of resource that performs operations on Entities.
#   such as damage, healing, adding cards, activating abilities,
#   etc.
#   Context for the action's user, targets, and scene elements like
#   where battle objects are or a reference to the player's cards
#   are accessed through ActionContext.
#   To be used as a creatable asset in paramater fields of CombatMove.
#
# ==========================================================

# Needs to be inherited to "exist"
@abstract

extends Resource
class_name AtomicAction

# TODO: When LLM Model is being implemented, create a dictionary that
# indexes every atomic action class so that it can create CombatMoves with
# atomic actions as building blocks

# Required for child classes to implement
@abstract
func execute(action_context:ActionContext)
# BattleActionInfo provides context like who is executing this action?
# what are they trying to hit?
# what actions should be queued?
# what object is infront of the player?
# what cards are in the player's hand?
