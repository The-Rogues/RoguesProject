extends Control
class_name FloatingTextSpawner

const TEXT = preload("res://common/floating_text/floating_text.tscn")

func create(text:String, color:Color = Color.WEB_GRAY):
	var new_pop_text = TEXT.instantiate()
	add_child(new_pop_text)
	
	new_pop_text.initialize(text, color)
