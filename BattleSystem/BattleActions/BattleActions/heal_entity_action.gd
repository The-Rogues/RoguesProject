extends TargetedBattleAction
class_name HealEntityAction

@export_range(1, 999) var health:int = 6

func _execute(battle_instance:BattleManager, action_user:BattleEntity):
	targeting = _resolve_target(battle_instance, action_user)
	
	for target in targeting:
		target.heal(health)
		await battle_instance.action_delay()
