extends ItemData
class_name StatusEffectItem

@export var effect:StatusEffectConfig

func use_item(_player:PlayerEntity = null) -> bool:
	if _player:
		_player.apply_status_effect(effect, true)
		return true
	
	return false
