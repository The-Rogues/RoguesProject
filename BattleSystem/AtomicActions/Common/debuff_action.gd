# ==========================================================
# Author: Fabian 
# Description:
#   An editable resource that performs a debuff operation on
#   an entity's attack or defense multiplier.
#   To be used as a creatable asset in paramater fields of CombatMove.
#
# ==========================================================

extends AtomicAction
class_name DebuffAction
enum Weaken_Stat {ATTACK, DEFENSE}
enum Multiplier {XHalf, XQuarter}
@export var weaken_stat:Weaken_Stat
@export var multiplier:Multiplier

# TODO: Currently buffs persist, consider making them temporary
#  having the entity recover after X turns

func execute(action_context:ActionContext):
	var multiplier_value:float
	var battle_object = action_context.battle_field.get_object_infront_of_player()
	
	match  multiplier:
		Multiplier.XHalf:
			multiplier_value = 0.5
			pass
		Multiplier.XQuarter:
			multiplier_value = 0.25
			pass
	
	for target in action_context.targets:
		# Debuffs can be avoided if target (character) is behind protective
		# cover
		if battle_object:
			battle_object.take_damage(0, action_context.user)
			
			if battle_object.blocks_attacker(action_context.user):
				await battle_object.entity_animator.animation_finished
				return
		
		if weaken_stat == Weaken_Stat.ATTACK:
			target.debuff_attack(multiplier_value)
		elif weaken_stat == Weaken_Stat.DEFENSE:
			target.debuff_defense(multiplier_value)
		await target.entity_animator.animation_finished
