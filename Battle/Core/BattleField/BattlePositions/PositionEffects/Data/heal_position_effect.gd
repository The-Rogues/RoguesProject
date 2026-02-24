extends PositionEffectData
class_name HealPositionEffect

func on_entered(entity:BattleEntity):
	entity.heal(randi_range(4, 12))
	ended.emit()
