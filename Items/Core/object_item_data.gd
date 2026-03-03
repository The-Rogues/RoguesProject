extends ItemData
class_name ObjectItem

@export var object:ObjectEntityData

func use_item(_battle_instance:BattleManager = null) -> void:
	_battle_instance.player_entity.carry_object(object)
