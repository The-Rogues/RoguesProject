extends Resource
class_name ObjectBehaviour


func on_position_entered(_object:ObjectEntity, _player:PlayerEntity):
	pass


func on_position_exited(_object:ObjectEntity, _player:PlayerEntity):
	pass


func on_turn_entered(_object:ObjectEntity, turn_count:int):
	pass


func on_object_hit(_object:ObjectEntity, _attacker:AbstractEntity):
	pass


func on_object_interacted(_object:ObjectEntity, _player:PlayerEntity):
	pass
