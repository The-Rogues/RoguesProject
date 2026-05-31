extends Node

@export var select_buttons:Array[Button]
@onready var hover_sound: AudioStreamPlayer = $HoverSound
@onready var start_sound: AudioStreamPlayer = $StartSound
@onready var select_sound: AudioStreamPlayer = $SelectSound
@onready var credits_return: Button = %ReturnCredits
@onready var close_sound: AudioStreamPlayer = $CloseSound


func _ready() -> void:
	for button in select_buttons:
		button.mouse_entered.connect(_on_button_hovered.bind(button))
		button.button_up.connect(
			func():
				start_sound.play()
		)
	
	if credits_return:
		credits_return.button_up.connect(func(): close_sound.play())


func _on_button_hovered(button:Button):
	if !button.disabled and button.visible:
		hover_sound.play()
	pass
