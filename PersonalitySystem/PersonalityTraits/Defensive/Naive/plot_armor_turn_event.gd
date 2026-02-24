extends BattleTurnEvent
class_name PlotArmorTurnEvent

@export_range(1,99) var duration:int = 1

func initialize(new_battle_instance:BattleManager) -> void:
	super(new_battle_instance)
	new_battle_instance.new_turn_started.connect(_on_new_turn_started)
	new_battle_instance.player_entity.ignore_projectiles = true

func _on_new_turn_started():
	duration -= 1
	if duration == 0:
		battle_instance.player_entity.ignore_projectiles = false
		event_ended.emit(self)
		battle_instance.new_turn_started.disconnect(_on_new_turn_started)
