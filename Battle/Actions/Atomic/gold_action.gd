extends BattleAction
class_name GoldAction

@export var min_gold:int
@export var bonus_gold:int

func _execute(battle_instance:BattleManager, action_user:BattleEntity):
	if GlobalSessionManager.run_progress:
		GlobalSessionManager.increase_gold(
				randi_range(min_gold, min_gold + bonus_gold)
		)
