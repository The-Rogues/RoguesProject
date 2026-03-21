extends DamageValue
class_name OffenseDamageValue

func get_damage(
	_battle_instance:BattleManager = null, 
	_user:BattleEntity = null
):
	return damage + _battle_instance.player_personality.offensive_weight
