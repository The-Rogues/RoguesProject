extends RefCounted
class_name CardInstance

signal updated(instance:CardInstance)

var cost:int
var data:CardData
var player:BattleEntity

func _init(
	card_data:CardData,
) -> void:
	data = card_data
	cost = card_data.energy_cost


func update_instance():
	updated.emit()


func get_stack_value(
) -> int:
	if data is AiCardData:
		return -1
	if player == null:
		return -1
	
	if data.move.actions[0] is AttackAction:
		print("Attack found, returning: ", data.move.actions[0].damage_sample.get_damage(player))
		return data.move.actions[0].damage_sample.get_damage(player)
	
	return -1
