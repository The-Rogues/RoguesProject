extends MiniEventResult
class_name RandomResult

@export var results: Array[MiniEventResult]
@export var weights: Array[float]

var chosen_result: MiniEventResult


func resolve():
	if results.is_empty():
		return
	
	if weights.size() != results.size():
		push_error("Weights and results size mismatch")
		return
	
	var index := _get_weighted_index()
	chosen_result = results[index]
	chosen_result.resolve()


func get_result_text() -> String:
	if chosen_result:
		return chosen_result.get_result_text()
	return ""


func _get_weighted_index() -> int:
	var total := 0.0
	for w in weights:
		total += w
	
	var roll := randf() * total
	var cumulative := 0.0
	
	for i in range(weights.size()):
		cumulative += weights[i]
		if roll <= cumulative:
			return i
	
	return weights.size() - 1
