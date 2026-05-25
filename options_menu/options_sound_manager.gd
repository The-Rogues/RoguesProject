extends Node

@onready var close_sound: AudioStreamPlayer = $CloseSound
@onready var hover_sound: AudioStreamPlayer = $HoverSound
@onready var click_sound: AudioStreamPlayer = $ClickSound
@export var buttons:Array[Button]


func _ready() -> void:
	for button in buttons:
		button.mouse_entered.connect(hover_sound.play)
		button.pressed.connect(click_sound.play)
	
	#%MainMenu.pressed.connect(click_sound.play)
	#%Close.pressed.connect(click_sound.play)
