extends ItemData
class_name KoalaPlushItemData


func use_item(_player:PlayerEntity = null) -> bool:
	if _player:
		_player.offensive_trait.reset_weight()
		_player.defensive_trait.reset_weight()
		_player.strategic_trait.reset_weight()
		return true
	return false
