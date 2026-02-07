# ==========================================================
# Author: Fabian 
# Description:
#   An editable resource that performs a heal operation on
#   an entity.
#   To be used as a creatable asset in paramater fields of CombatMove.
#
# ==========================================================

extends AtomicAction
class_name HealAction

@export var heal_amount:int = 0

func execute(action_context:ActionContext):
	for target in action_context.targets:
		# Entity handles its own heal logic
		target.heal(heal_amount)
		await  target.entity_animator.animation_finished
