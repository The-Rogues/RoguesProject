extends Node

@export var card:Card
@onready var card_hover: AudioStreamPlayer = $CardHover
@onready var card_click: AudioStreamPlayer = $CardClick
@onready var card_play: AudioStreamPlayer = $CardPlay


func _ready() -> void:
	card.mouse_entered.connect(
		func():
			if card.interaction_mode:
				var ran = randf_range(0.6, 0.8)
				card_hover.pitch_scale = ran
				card_hover.play()
	)
	
	card.clicked.connect(
		func(c):
			if card.interaction_mode:
				var ran = randf_range(0.6, 0.8)
				card_click.pitch_scale = ran
				card_click.play()
	)
	
	card.launched.connect(
		func():
			if card.interaction_mode:
				var ran = randf_range(0.8, 1.0)
				card_play.pitch_scale = ran
				card_play.play()
	)
