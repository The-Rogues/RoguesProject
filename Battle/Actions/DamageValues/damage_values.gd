extends Resource
class_name DamageValue

@export var damage:int = 6

func get_damage(
	_user:BattleEntity = null
):
	return _user.get_attack_damage(damage)
