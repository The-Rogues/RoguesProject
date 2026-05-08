extends Node

@onready var close_sound: AudioStreamPlayer = $CloseSound
@onready var hover_sound: AudioStreamPlayer = $HoverSound
@onready var click_sound: AudioStreamPlayer = $ClickSound
@onready var back: Button = $"../MarginContainer/VBoxContainer/Back"
@export var volume_sliders:Array[Slider]


func _ready() -> void:
	back.button_up.connect(
		func(): close_sound.play()
	)
	
	back.mouse_entered.connect(
		func(): hover_sound.play()
	)
	
	for slider in volume_sliders:
		slider.mouse_entered.connect(
			func(): hover_sound.play()
		)
		
		slider.drag_started.connect(
			func(): click_sound.play()
		)




func _on_music_toggle_toggled(toggled_on: bool) -> void:
	click_sound.play()
	pass # Replace with function body.
