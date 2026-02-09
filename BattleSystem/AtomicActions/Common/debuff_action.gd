extends AtomicAction
class_name DebuffAction
## AtomicAction that applies a temporary combat debuff to targeted battle
## entities.
##
## Deamplifies either attack or defense effectiveness for all targets in
## the action context by a predefined decrease for a set number of turns.
## Yields for a breif period before finishing execution.
##
## Player entity can currently avoid debuffs by standing behind battle
## objects that provide cover.

enum Stat_Category {ATTACK, DEFENSE}
enum Reduce {HALF, QUARTER}
## Controls if the target's attack or defense is reduced by this action
@export var stat:Stat_Category
## Controls the multiplier for reducing the stat
## Half will double decrease by 50% and Quarter will decrease by 25%
## Reductions will stack until maximum is reached which is 50%
@export var reduce:Reduce
## Controls the number of turns the debuff will remain active
@export_range(1, 99) var turns:int = 3


# TODO: Creating a timer on the tree for pausing execution isn't reccomended
# in most cases. Consider having damage response time stored locally in 
# entity class
func execute(action_context:ActionContext):
	var reduce_value:float
	var battle_object = action_context.battle_field.get_object_infront_of_player()
	
	match  reduce:
		Reduce.HALF:
			reduce_value = 0.5
			pass
		Reduce.QUARTER:
			reduce_value = 0.25
			pass
	
	for target in action_context.targets:
		if battle_object:
			battle_object.take_damage(0, action_context.user)
			
			if battle_object.blocks_attacker(action_context.user):
				await battle_object.get_tree().create_timer(0.15).timeout
				return
		
		if stat == Stat_Category.ATTACK:
			target.debuff_attack(reduce_value, turns)
		elif stat == Stat_Category.DEFENSE:
			target.debuff_defense(reduce_value, turns)
		await target.get_tree().create_timer(0.15).timeout
