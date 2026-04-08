extends ItemData
class_name ObjectItem

@export var object:ObjectData

func use_item(_player:PlayerEntity = null) -> bool:
	if _player:
		return _player.carry_object(object)
	
	return false
