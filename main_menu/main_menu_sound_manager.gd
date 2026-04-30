extends Node

@export var select_buttons:Array[SelectButton]
@export var start_button:Array[SelectButton]
@onready var hover_sound: AudioStreamPlayer = $HoverSound
@onready var start_sound: AudioStreamPlayer = $StartSound
@onready var select_sound: AudioStreamPlayer = $SelectSound


func _ready() -> void:
	for button in select_buttons:
		button.mouse_entered.connect(
			func():
				hover_sound.play())
		button.clicked.connect(
			func():
				select_sound.play()
		)
	
	for button in start_button:
		button.clicked.connect(
			func():
				start_sound.play())
