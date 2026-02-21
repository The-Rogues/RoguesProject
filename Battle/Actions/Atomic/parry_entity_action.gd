extends TargetedBattleAction
class_name ParryEntityAction

@export_range(1, 999) var parry:int = 6

func _execute(battle_instance:BattleManager, action_user:BattleEntity):
	targeting = _resolve_target(battle_instance, action_user)
	
	for target in targeting:
		target.parry.add_parry(parry)
		await battle_instance.action_delay()
