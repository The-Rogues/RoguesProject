extends Timer

@export var control:Control

func _on_timeout() -> void:
	if !control:
		return
	
	# Fade out (disappear)
	var tween = create_tween()
	tween.tween_property(control, "modulate:a", 0.0, 1.0)
