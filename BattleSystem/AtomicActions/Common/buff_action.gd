# ==========================================================
# Author: Fabian 
# Description:
#   An editable resource that performs a buff operation on
#   an entity's attack or defense multiplier.
#   To be used as a creatable asset in paramater fields of CombatMove.
#
# ==========================================================

extends AtomicAction
class_name BuffAction

enum Amplify_Stat {ATTACK, DEFENSE}
enum Multiplier {X2, X1_5, X1_25}
@export var amplify_stat:Amplify_Stat
@export var multiplier:Multiplier

# TODO: Currently buffs persist, consider making them temporary
#  having the entity recover after X turns

func execute(action_context:ActionContext):
	var multiplier_value:float
	
	match  multiplier:
		Multiplier.X2:
			multiplier_value = 1.0
			pass
		Multiplier.X1_5:
			multiplier_value = 0.5
			pass
		Multiplier.X1_25:
			multiplier_value = 0.25
			pass
	
	for target in action_context.targets:
		if amplify_stat == Amplify_Stat.ATTACK:
			target.buff_attack(multiplier_value)
		elif amplify_stat == Amplify_Stat.DEFENSE:
			target.buff_defense(multiplier_value)
		await target.entity_animator.animation_finished
