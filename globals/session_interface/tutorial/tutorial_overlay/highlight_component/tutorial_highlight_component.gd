extends Panel
class_name TutorialHighlightComponent

var elapsed_time: float = 0.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	elapsed_time += delta
	
	var stylebox: StyleBoxFlat = StyleBoxFlat.new()
	stylebox.bg_color = Color(0.25, 0.75, 0, 0.3 * abs(sin(elapsed_time * 2))) # Set desired background color
	stylebox.border_width_left = 10
	stylebox.border_width_top = 10
	stylebox.border_width_right = 10
	stylebox.border_width_bottom = 10
	stylebox.border_color = Color(0.25, 0.75, 0, 0.8 * abs(sin(elapsed_time * 2)))
	stylebox.border_blend = true
	stylebox.corner_detail = 8
	
	add_theme_stylebox_override("panel", stylebox)
