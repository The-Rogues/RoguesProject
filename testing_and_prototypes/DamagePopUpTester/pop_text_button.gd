extends Button

const pop_text = preload("res://GeneralAssets/UI/PopNumbers/pop_numbers.tscn")

func _on_button_up() -> void:
	var new_pop_text = pop_text.instantiate()
	get_tree().add_child(new_pop_text)
	new_pop_text.initialize(str(randi_range(2, 20)), Color.RED)
	pass # Replace with function body.
