extends Label
class_name PopNumbers

var active:bool = false
@export var speed:float = 60.0
@onready var life_timer: Timer = $LifeTimer

func _ready() -> void:
	visible = false

func initialize(new_text:String, color:Color = Color.BROWN):
	active = true
	visible = true
	life_timer.start()
	text = new_text
	self_modulate = color

func _process(delta: float) -> void:
	if !active:
		return
	
	global_position.y -= speed * delta

func _on_life_timer_timeout() -> void:
	queue_free()
	pass # Replace with function body.
