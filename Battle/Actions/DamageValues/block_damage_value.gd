extends DamageValue
class_name BlockDamageValue

func get_damage(
	_user:BattleEntity = null
):
	return damage + _user.defense.current_defense
