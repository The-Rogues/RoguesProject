extends Control

@export var context_panel: ContextPanel
var screen_size: Vector2

func _ready() -> void:
	screen_size = get_viewport().size
	
	var screen_middle_y = screen_size.y * 0.5
	
	# If object is above the middle move panel DOWN
	if global_position.y < screen_middle_y:
		context_panel.global_position.y += 50
	else:
		# If object is below the middle move panel UP
		context_panel.global_position.y -= 50
	
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func _on_mouse_entered():
	if !visible:
		return
	context_panel.visible = true

func _on_mouse_exited():
	if !visible:
		return
	context_panel.visible = false
