extends BattleAction
class_name BattleEventAction
## Action for adding a rule to a batte. Use as components to build [BattleMove].

@export var battle_turn_event:BattleTurnEvent

## Adds a rule to a battle.
func _execute(battle_instance:BattleManager, _action_user:BattleEntity = null):
	battle_instance.battle_events.add_event(battle_turn_event, _action_user)
