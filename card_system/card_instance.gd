extends RefCounted
class_name CardInstance

signal updated

var energy_cost:int
var data:CardData


func _init(
	_data:CardData,
) -> void:
	data = _data
	energy_cost = _data.energy_cost


func change_cost(amount:int):
	energy_cost = amount
	updated.emit()


func update_instance(_effect:ActiveStatusEffect):
	updated.emit()
