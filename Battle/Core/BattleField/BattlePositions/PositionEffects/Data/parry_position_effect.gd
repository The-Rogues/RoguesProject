extends PositionEffectData
class_name ParryPositionEffect

func on_entered(entity:BattleEntity):
	entity.parry.add_parry(randi_range(2, 3))
	ended.emit()
