extends BattleTurnEvent
class_name ConserveEnergyEvent

var stored_energy:int = 0

func initialize(
		new_battle_instance:BattleManager, 
		user:BattleEntity = null
) -> void:
	super(new_battle_instance)
	new_battle_instance.player_turn_ended.connect(_on_ended_player_turn)
	new_battle_instance.new_turn_started.connect(_on_new_turn_started)
	display_floating_numbers(
		"Conserving",
		battle_instance.player_entity
	)

func _on_ended_player_turn():
	stored_energy = battle_instance.energy_counter.energy

func _on_new_turn_started():
	display_floating_numbers(
		"Conserved " + str(stored_energy),
		battle_instance.player_entity
	)
	battle_instance.energy_counter.add_energy(stored_energy)
	event_ended.emit(self)
