extends RefCounted
class_name BattleEventsManager

var battle_instance:BattleManager
var battle_events:Array[BattleTurnEvent] = []


func initialize(
	new_battle_instance:BattleManager
) -> void:
	battle_instance = new_battle_instance


func add_event(battle_event:BattleTurnEvent, user:BattleEntity = null) -> void:
	for instance in battle_events:
		if battle_events.has(instance):
			if instance.associated_entity == user:
				instance.on_stack()
			return
	
	battle_event.initialize(battle_instance, user)
	battle_events.append(battle_event)
	battle_event.event_ended.connect(_on_event_ended)


func remove_event(battle_event:BattleTurnEvent) -> bool:
	for instance in battle_events:
		if battle_events.has(instance):
			battle_events.erase(battle_event)
			return true
	return false


func get_event(event_script:Script, owner:BattleEntity) -> BattleTurnEvent:
	for event in battle_events:
		if event.get_script() == event_script:
			if owner != null and event.associated_entity == owner:
				return event
	return null


func _on_event_ended(battle_event:BattleTurnEvent):
	remove_event(battle_event)
