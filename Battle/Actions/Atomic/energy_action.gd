extends BattleAction
class_name EnergyAction

@export var energy:int

func _execute(battle_instance:BattleManager, action_user:BattleEntity):
	battle_instance.energy_counter.add_energy(energy)
