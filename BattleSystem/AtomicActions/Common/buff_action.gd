extends AtomicAction
class_name BuffAction
## AtomicAction that applies a temporary combat buff to targeted battle
## entities.
##
## Amplifies either attack or defense effectiveness for all targets in
## the action context by a predefined increase for a set number of turns.
## Yields for a breif period before finishing execution.

enum Stat_Category {ATTACK, DEFENSE}
enum Increase {DOUBLE, HALF, QUARTER}
@export var stat:Stat_Category
@export var increase:Increase
@export_range(1, 99) var turns:int = 3


func execute(action_context:ActionContext):
	var increase_value:float
	
	match  increase:
		Increase.DOUBLE:
			increase_value = 1.0
			pass
		Increase.HALF:
			increase_value = 0.5
			pass
		Increase.QUARTER:
			increase_value = 0.25
			pass
	
	for target in action_context.targets:
		if stat == Stat_Category.ATTACK:
			target.buff_attack(increase_value, turns)
		elif stat == Stat_Category.DEFENSE:
			target.buff_defense(increase_value, turns)
		await target.get_tree().create_timer(0.15).timeout
