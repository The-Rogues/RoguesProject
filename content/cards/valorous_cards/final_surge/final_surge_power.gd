extends BattlePower
class_name FinalSurgePower

var discount_amount: int = 0
var player: PlayerEntity

func on_apply(_context:BattleContext):
	player = _context.get_player()
	player.offensive_trait.updated_trait_weight.connect(_on_weight_changed)
	player.defensive_trait.updated_trait_weight.connect(_on_weight_changed)
	player.strategic_trait.updated_trait_weight.connect(_on_weight_changed)
	player.cards.drew_card.connect(_on_card_drawn)

func _on_weight_changed(_ignore: int):
	discount_amount += 1
	discount_hand_cards()

func _on_card_drawn(card:CardInstance):
	if card.data.name == "Final Surge" && is_instance_valid(player):
		var base_cost: int = 10
		base_cost -= discount_amount
		if base_cost < 0:
			base_cost = 0
		card.energy_cost = base_cost
		card.update_instance(null)

func discount_hand_cards():
	if is_instance_valid(player):
		
		var cards = player.cards.get_cards_by_name("Final Surge")
		if cards.size() == 0:
			return
		
		var base_cost: int = 10
		base_cost -= discount_amount
		if base_cost < 0:
			base_cost = 0
		
		for i in range(0, cards.size()):
			cards[i].energy_cost = base_cost
			cards[i].update_instance(null)
