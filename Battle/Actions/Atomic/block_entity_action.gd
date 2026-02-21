extends TargetedBattleAction
class_name BlockEntityAction

@export_range(1, 999) var block:int = 6

func _execute(battle_instance:BattleManager, action_user:BattleEntity):
	targeting = _resolve_target(battle_instance, action_user)
	
	for target in targeting:
		target.defense.add_defense(block)
		await battle_instance.action_delay()
