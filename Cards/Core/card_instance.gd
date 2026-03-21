extends RefCounted
class_name CardInstance


signal modified(instance:CardInstance)


var stack:int
var cost:int
var data:CardData

func _init(
	card_data:CardData
) -> void:
	data = card_data
	cost = card_data.energy_cost
	stack = 0


func execute():
	
	pass
