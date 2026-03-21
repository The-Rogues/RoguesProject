extends ItemData
class_name BattleEventItem

@export var effect:BattleTurnEvent
@export var use_player:bool = false

func use_item(_battle_instance:BattleManager = null) -> bool:
	if !_battle_instance:
		return false
	
	if use_player:
		_battle_instance.battle_events.add_event(effect, _battle_instance.player_entity)
	else:
		_battle_instance.battle_events.add_event(effect)
	
	return true
