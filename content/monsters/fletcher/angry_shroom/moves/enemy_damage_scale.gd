extends EnemyMove
class_name EnemyDamageScale

# Fabian - EnemyMove has been generalized to just EnemyMove. Dynamic descriptions
# now work for enemy intents the same way that they do for cards.
# See intent_tooltip.gd, intent_icon.gd, and damage_scale_action.gd

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
