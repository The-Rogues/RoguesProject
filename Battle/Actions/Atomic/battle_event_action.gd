extends BattleAction
class_name BattleEventAction

@export var battle_turn_event:BattleTurnEvent

func _execute(battle_instance:BattleManager, action_user:BattleEntity):
	battle_instance.battle_events.add_event(battle_turn_event)
