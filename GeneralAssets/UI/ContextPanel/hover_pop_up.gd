extends Control

@export var context_panel:ContextPanel
var screen_size:Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport().size
	if global_position.y > 0:
		context_panel.global_position.y -= 50
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	pass # Replace with function body.

func _on_mouse_entered():
	if !visible:
		return
	context_panel.visible = true
	pass

func _on_mouse_exited():
	if !visible:
		return
	context_panel.visible = false
	pass
