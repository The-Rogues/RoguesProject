extends PanelContainer
class_name BannerPopup

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func display(text:String):
	$Label.text = text
	animation_player.play("display")
	await animation_player.animation_finished
