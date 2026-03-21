extends Resource
class_name DamageValue

@export var damage:int = 6

func get_damage(
	_battle_instance:BattleManager = null, 
	_user:BattleEntity = null
):
	return damage
