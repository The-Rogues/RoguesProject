extends Control

signal name_saved(new_name:String)

@onready var text_edit: TextEdit = %LimitedTextEdit
@onready var save: Button = %Save


func _ready() -> void:
	_on_name_text_updated()


func _on_name_text_updated() -> void:
	save.disabled = text_edit.text.is_empty()
	pass # Replace with function body.


func _on_save_button_up() -> void:
	name_saved.emit(text_edit.text)
	visible = false
	pass # Replace with function body.


func _on_cancel_button_up() -> void:
	visible = false
	pass # Replace with function body.
