extends Label
class_name SelectButton

signal clicked
@onready var texture_rect: TextureRect = $TextureRect
@export var disabled:bool = false

func _ready() -> void:
	set_disabled(disabled)

func set_disabled(disable:bool):
	if disable:
		self_modulate = Color.DIM_GRAY
		disabled = true
	else:
		self_modulate = Color.WHITE
		disabled = false


func _on_mouse_entered() -> void:
	if disabled:
		return
	
	texture_rect.visible = true
	pass # Replace with function body.


func _on_mouse_exited() -> void:
	if disabled:
		return
	
	texture_rect.visible = false
	pass # Replace with function body.


func _on_gui_input(event: InputEvent) -> void:
	if disabled:
		return
	
	if event is InputEventMouseButton:
		if event.is_released():
			clicked.emit()
	pass # Replace with function body.
