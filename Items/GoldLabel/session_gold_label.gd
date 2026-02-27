extends Label

var added_gold:bool = false
@export var gold:float = 0


func _ready() -> void:
	if GlobalSessionManager.run_progress:
		gold = GlobalSessionManager.run_progress.gold
		GlobalSessionManager.gold_updated.connect(_on_gold_updated)
	
	text = str( int( round(gold) ) )


func _process(_delta: float) -> void:
	if added_gold:
		text = str( int( round( gold ) ) )


func _on_gold_updated(new_amount: int) -> void:
	var total = min(new_amount, 99999)
	
	added_gold = true
	var tween := create_tween()
	tween.tween_property(self, "gold", total, 1.65)
	await tween.finished
	added_gold = false
