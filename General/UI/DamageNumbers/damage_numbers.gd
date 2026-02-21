extends Control
class_name DamageNumbers
## Control node that creates floating damage numbers when a specified entity is
## damaged or healed
##
## Connect functions to damage and heal signals

const FLOATING_NUMBERS = preload(
		"res://General/UI/DamageNumbers/floating_numbers.tscn"
)

func display_damage_numbers(amount:int):
	var new_pop_text = FLOATING_NUMBERS.instantiate()
	add_child(new_pop_text)
	
	if amount == 0:
		new_pop_text.initialize("0", Color.DARK_SLATE_GRAY)
	else:
		new_pop_text.initialize("-" + str(amount), Color.CRIMSON)
	pass


func display_heal_numbers(amount:int):
	var new_pop_text = FLOATING_NUMBERS.instantiate()
	add_child(new_pop_text)
	
	new_pop_text.initialize("+" + str(amount), Color.SEA_GREEN)
