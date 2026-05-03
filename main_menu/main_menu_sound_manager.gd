extends Node

@export var select_buttons:Array[SelectButton]
@export var start_button:Array[SelectButton]
@onready var hover_sound: AudioStreamPlayer = $HoverSound
@onready var start_sound: AudioStreamPlayer = $StartSound
@onready var select_sound: AudioStreamPlayer = $SelectSound
@onready var credits_return: Button = $"../CreditsMenu/Return"
@onready var close_sound: AudioStreamPlayer = $CloseSound


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
	
	credits_return.button_up.connect(func(): close_sound.play())
