extends Node
# Code from DashNothing: https://www.youtube.com/watch?v=F0DQLSiLkjg&t=1s


func display_number(value:int, position:Vector2):
	
	var label = Label.new()
	label.global_position = position
	label.text = str(value)
	label.z_index = 4
	label.label_settings = LabelSettings.new()
	label.label_settings.font = load("res://common/fonts/dungeon-mode.ttf")
	label.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	
	var color = Color.WHITE
	if value == 0:
		color = Color.GRAY
	
	label.label_settings.font_color = color
	label.label_settings.font_size = 20
	label.label_settings.outline_color = Color.BLACK
	label.label_settings.outline_size = 4
	
	call_deferred("add_child", label)
	
	await label.resized
	label.pivot_offset = Vector2(label.size / 2)
	
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	
	tween.tween_property(
			label,
			"position:y",
			label.position.y - 24,
			0.25).set_ease(Tween.EASE_OUT)
	tween.tween_property(
			label,
			"position:y",
			label.position.y,
			0.5).set_ease(Tween.EASE_IN).set_delay(0.25)
	tween.tween_property(
			label,
			"scale",
			Vector2.ZERO,
			0.25).set_ease(Tween.EASE_OUT).set_delay(0.5)
	
	await tween.finished
	label.queue_free()
