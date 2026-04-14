extends ItemData
class_name KeyItem

@export var key_id:String

func use_item(_player:PlayerEntity = null) -> bool:
	return false
