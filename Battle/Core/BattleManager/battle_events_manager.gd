extends RefCounted
class_name BattleEventsManager

var battle_instance:BattleManager
var battle_events:Array[BattleTurnEvent] = []

func initialize(
	new_battle_instance:BattleManager
) -> void:
	battle_instance = new_battle_instance


func add_event(battle_event:BattleTurnEvent) -> void:
	for instance in battle_events:
		if battle_events.has(instance):
			return
	
	battle_event.initialize(battle_instance)
	battle_events.append(battle_event)
	battle_event.event_ended.connect(_on_event_ended)


func remove_event(battle_event:BattleTurnEvent) -> bool:
	for instance in battle_events:
		if battle_events.has(instance):
			battle_events.erase(battle_event)
			return true
	return false


func _on_event_ended(battle_event:BattleTurnEvent):
	remove_event(battle_event)
