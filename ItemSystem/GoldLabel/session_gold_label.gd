extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_on_gold_updated(GlobalSessionManager.run_progress.gold)
	GlobalSessionManager.gold_updated.connect(_on_gold_updated)
	pass # Replace with function body.


func _on_gold_updated(new_amount:int):
	text = str(GlobalSessionManager.run_progress.gold) + "G"
