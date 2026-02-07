extends CanvasLayer
class_name ScreenFadeLayer

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func fade_in():
	animation_player.play_backwards("fade_layer/fade_out")
	await animation_player.animation_finished

func fade_out():
	animation_player.play("fade_layer/fade_out")
	await animation_player.animation_finished
