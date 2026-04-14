extends PanelContainer

signal clicked_yes
signal clicked_no



func _on_yes_clicked() -> void:
	clicked_yes.emit()
	visible = false
	pass # Replace with function body.


func _on_no_clicked() -> void:
	clicked_no.emit()
	visible = false
	pass # Replace with function body.
