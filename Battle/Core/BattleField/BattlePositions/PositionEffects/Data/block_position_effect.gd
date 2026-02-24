extends PositionEffectData
class_name BlockPositionEffect

func on_entered(entity:BattleEntity):
	entity.defense.add_defense(randi_range(2, 4))
	ended.emit()
