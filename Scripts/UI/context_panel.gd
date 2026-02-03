extends PanelContainer
class_name ContextPanel

@export_multiline var context_text:String

func _ready() -> void:
	if !context_text.is_empty():
		set_context(context_text)

func set_context(new_context_text:String):
	$MarginContainer/Label.text = new_context_text
