extends CanvasLayer
class_name ScreenFade

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func fade_in():
	animation_player.play("fade_in")
	await animation_player.animation_finished


func fade_out():
	animation_player.play_backwards("fade_in")
	await animation_player.animation_finished
