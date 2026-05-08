extends BattlePower
class_name PracticePerfectPower

var player: PlayerEntity

func on_apply(_context:BattleContext):
	player = _context.get_player()
	_context.get_player().defensive_trait.updated_trait_weight.connect(discount_hand_cards)
	_context.get_player().cards.drew_card.connect(_on_card_drawn)

func _on_card_drawn(card:CardInstance):
	if card.data.name == "Practice Makes Perfect" && is_instance_valid(player):
		var base_cost: int = 6
		for i in range(0, player.defensive_trait.weight_value + 1, 2):
			if i == 0:
				continue
			base_cost -= 2
		if base_cost < 0:
			base_cost = 0
		card.energy_cost = base_cost
		card.update_instance(null)

func discount_hand_cards(def_amnt: int):
	if is_instance_valid(player):
		
		var cards = player.cards.get_cards_by_name("Practice Makes Perfect")
		if cards.size() == 0:
			return
		
		var base_cost: int = 6
		for i in range(0, def_amnt + 1, 2):
			if i == 0:
				continue
			base_cost -= 2
		if base_cost < 0:
			base_cost = 0
		for i in range(0, cards.size()):
			cards[i].energy_cost = base_cost
			cards[i].update_instance(null)
