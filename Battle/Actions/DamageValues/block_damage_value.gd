extends DamageValue
class_name BlockDamageValue

func get_damage(
	_battle_instance:BattleManager = null,
	_user:BattleEntity = null
):
	return damage + _user.defense.current_defense
