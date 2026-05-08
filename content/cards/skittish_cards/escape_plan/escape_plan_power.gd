extends BattlePower
class_name EscapePlanPower


func on_apply(_context:BattleContext):
	_context.get_player().cards.drew_card.connect(_on_card_drawn)
	for card in _context.get_player().cards.drawn_cards:
		if _is_movement_card(card.data):
			card.change_cost(0)


func _on_card_drawn(card: CardInstance):
	if _is_movement_card(card.data):
		card.change_cost(0)


func _is_movement_card(data: CardData) -> bool:
	for action in data.play_actions:
		if action is MovePlayerAction:
			return true
	
	return false
