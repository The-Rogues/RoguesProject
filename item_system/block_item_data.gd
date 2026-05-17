extends ItemData
class_name BlockItemData

@export_range(1, 99) var block:int = 1


func use_item(_player:PlayerEntity = null) -> bool:
	if _player:
		_player.block.add_block(block)
		return true
	return false
