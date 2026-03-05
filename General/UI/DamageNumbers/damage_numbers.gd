extends Control
class_name DamageNumbers
## Control node that creates floating damage numbers when a specified entity is
## damaged or healed
##
## Connect functions to damage and heal signals

signal damage_numbers_cleared

var active_numbers:int = 0

const FLOATING_NUMBERS = preload(
		"res://General/UI/DamageNumbers/floating_numbers.tscn"
)

func display_damage_numbers(amount:int):
	var new_pop_text = FLOATING_NUMBERS.instantiate()
	add_child(new_pop_text)
	active_numbers += 1
	new_pop_text.finished.connect(_number_finished)
	
	if amount == 0:
		new_pop_text.initialize("0", Color.DARK_SLATE_GRAY)
	else:
		new_pop_text.initialize("-" + str(amount), Color.CRIMSON)
	pass

func _number_finished():
	active_numbers -= 1
	
	if active_numbers == 0:
		damage_numbers_cleared.emit()


func display_heal_numbers(amount:int):
	var new_pop_text = FLOATING_NUMBERS.instantiate()
	add_child(new_pop_text)
	
	new_pop_text.initialize("+" + str(amount), Color.SEA_GREEN)
