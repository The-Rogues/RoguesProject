extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_on_gold_updated(GlobalSessionManager.get_gold())
	GlobalSessionManager.gold_updated.connect(_on_gold_updated)
	pass # Replace with function body.


func _on_gold_updated(new_amount:int):
	text = str(GlobalSessionManager.get_gold()) + "G"
