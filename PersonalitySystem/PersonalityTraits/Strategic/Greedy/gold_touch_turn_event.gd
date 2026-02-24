extends BattleTurnEvent
class_name GoldTouchTurnEvent

@export var gold:int = 100

func initialize(new_battle_instance:BattleManager) -> void:
	super(new_battle_instance)
	for enemy in battle_instance.living_enemies:
		enemy.defeated.connect(_on_enemy_defeated)
	battle_instance.new_turn_started.connect(_on_new_turn_started)


func _on_enemy_defeated(battle_entity:BattleEntity):
	GlobalSessionManager.increase_gold(gold)
	battle_entity.defeated.disconnect(_on_enemy_defeated)

func _on_new_turn_started():
	for enemy in battle_instance.living_enemies:
		enemy.defeated.disconnect(_on_enemy_defeated)
	battle_instance.new_turn_started.disconnect(_on_new_turn_started)
	event_ended.emit(self)
