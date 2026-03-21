extends ItemData
class_name KeyItem

@export var key_id:String

func use_item(_battle_instance:BattleManager = null) -> bool:
	return false
