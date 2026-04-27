extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func rsize(vec):
	custom_minimum_size = vec
	size = vec

func _on_mouse_entered() -> void:
	print("test") # Replace with function body.


func _on_collision_box_mouse_entered() -> void:
	print("Hello") # Replace with function body.
