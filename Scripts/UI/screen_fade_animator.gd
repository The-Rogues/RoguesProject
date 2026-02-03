extends AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	play("fade_out")
	animation_finished.connect(finished_fade_out)
	pass # Replace with function body.

func finished_fade_out():
	stop()
	$"../Control/Panel".visible = false
