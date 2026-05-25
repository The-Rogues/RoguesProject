extends ItemData
class_name EnergyItemData

@export_range(1, 99) var energy:int = 1


func use_item(_player:PlayerEntity = null) -> bool:
	if _player:
		_player.energy.set_energy(
			_player.energy.value + energy,
			_player.energy.max_value)
		return true
	return false
