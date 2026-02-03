extends Area2D

@onready var label: Label = $Label

func _on_area_exited(area: Area2D) -> void:
	label.visible = false
	pass # Replace with function body.


func _on_area_entered(area: Area2D) -> void:
	label.visible = true
	pass # Replace with function body.
