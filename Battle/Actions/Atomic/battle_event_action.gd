extends BattleAction
class_name BattleEventAction
## An action dedicated to applying a battle rule to a battle

@export var battle_turn_event:BattleTurnEvent

## Adds a rule to a battle.
func _execute(battle_instance:BattleManager, _action_user:BattleEntity = null):
	battle_instance.battle_events.add_event(battle_turn_event, _action_user)
