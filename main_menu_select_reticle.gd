extends Control

@onready var reticle: TextureRect = %Reticle
@export var buttons:Array[Button]

const Offset_X = 32

func _ready() -> void:
	for button in buttons:
		button.mouse_entered.connect(focus_reticle.bind(button))


func hide_reticle(_hide:bool):
	reticle.visible = _hide


func focus_reticle(button:Button):
	if button.disabled:
		return
	
	var center = button.global_position + (button.size / 2)
	var reticle_position = center - (reticle.size / 2)
	reticle_position.x -= ((button.size.x / 2) + Offset_X)
	reticle.global_position = reticle_position
