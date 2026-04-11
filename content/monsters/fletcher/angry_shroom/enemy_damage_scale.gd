extends EnemyMove
class_name EnemyDamageScale

@export var init_damage: int
@export var scale_value: int

func get_actions() -> Array[Action]:
	var ret_val: Array[Action] = [AttackAction.new()]
	ret_val[0].base_damage = init_damage
	ret_val[0].hits = 1
	ret_val[0].target_option = TargetedAction.TargetOption.PLAYER
	init_damage += scale_value
	description = "This enemy intends to attack for " + str(init_damage) + " damage."
	return ret_val
