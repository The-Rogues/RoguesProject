extends Node

@export var select_buttons:Array[Button]
@export var toggle_button:Array[Button]
@onready var hover_sound: AudioStreamPlayer = $HoverSound
@onready var start_sound: AudioStreamPlayer = $StartSound
@onready var select_sound: AudioStreamPlayer = $SelectSound
@onready var close_sound: AudioStreamPlayer = $CloseSound


func _ready() -> void:
	for button in select_buttons:
		button.mouse_entered.connect(
			func():
				hover_sound.play())
		button.button_up.connect(
			func():
				start_sound.play()
		)
	
	for button in toggle_button:
		button.mouse_entered.connect(
			func():
				hover_sound.play())
		button.button_up.connect(
			func():
				select_sound.play()
		)
	
