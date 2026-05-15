extends BattlePower
class_name RetaliatePower

var player: PlayerEntity

func on_apply(_context:BattleContext):
	player = _context.get_player()
	_context.get_player().cards.drew_card.connect(_on_card_drawn)

func _on_card_drawn(card:CardInstance):
	if card.data.name == "Retaliate" && is_instance_valid(player):
		var base_cost: int = 3
		if player.damage_taken_last_turn > 0:
			base_cost -= 2
		card.energy_cost = base_cost
		card.update_instance(null)
