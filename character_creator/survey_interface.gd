extends HBoxContainer

signal option_selected(option:int)

var filled:bool = false


func select_random():
	var buttons:Array[Button] = []
	
	for option in get_children():
		if option is Button:
			buttons.append(option)
	
	
	var random_button_index:int = randi_range(0, buttons.size() - 1)
	buttons[random_button_index].set_pressed(true)
	option_selected.emit(random_button_index)
	filled = true


func _on_lower_button_up() -> void:
	option_selected.emit(0)
	filled = true
	pass # Replace with function body.


func _on_low_button_up() -> void:
	option_selected.emit(1)
	filled = true
	pass # Replace with function body.


func _on_high_button_up() -> void:
	option_selected.emit(2)
	filled = true
	pass # Replace with function body.


func _on_higher_button_up() -> void:
	option_selected.emit(3)
	filled = true
	pass # Replace with function body.
