extends Control

@onready var slf_stack: Control = $TooltipStack

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	slf_stack.init_stack(175, 3.5)
	slf_stack.position.x = slf_stack.position.x + 50
	slf_stack.append_group("0", Color(1.0, 0.173, 0.0, 1.0), Color(1.0, 0.353, 0.216, 1.0), Color(0.729, 0.125, 0.0, 1.0))
	slf_stack.append_tooltip("0", load("res://Map/map_assets/battle.png"), "Group 0", "Sample text.")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_mouse_entered() -> void:
	slf_stack.visible = true
	slf_stack.z_index = 150
