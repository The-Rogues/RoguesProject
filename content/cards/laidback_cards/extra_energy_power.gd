extends BattlePower
class_name ExtraEnergyPower

@export var extra_amnt: int = 1

func on_apply(_context:BattleContext):
	pass

func on_turn_entered(_context:BattleContext):
	var player: PlayerEntity = _context.get_player()
	player.energy.set_energy(
		player.energy.value + extra_amnt, 
		player.energy.max_value
	)
