# intended for battle actions that can't be simplified further
# such as heal x points to targets, move 1 spice left, repeat attack x times 

# Needs to be inherited to "exist"
@abstract
# Resource because instances of the same action with different input values will exist
# Example: Card A has DamageAction who's damage is 6, Card B damage is 9
extends Resource
class_name AtomicAction

# TODO: When LLM Model is being implemented, create a dictionary that is associated
# with an Atomic Action. Do not store token as a variable in this class

# Required for child classes to implement
@abstract
func execute(battle_info:BattleActionInfo)
# BattleActionInfo provides context like who is executing this action
# what are they trying to hit
# what actions should be queued
