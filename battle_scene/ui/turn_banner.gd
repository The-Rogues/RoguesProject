extends Control
class_name BannerPopup

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var label: Label = $BannerPopup/Label


func display(text:String):
	label.text = text
	animation_player.play("display")
	await animation_player.animation_finished
