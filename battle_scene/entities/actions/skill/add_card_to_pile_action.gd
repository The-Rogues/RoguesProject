extends Action
class_name AddCardToPileAction

enum PileOption {DISCARD, DRAW}
@export var card:CardData
@export var pile:PileOption = PileOption.DISCARD

func execute(_context:BattleContext = null, _user:AbstractEntity = null):
	if pile == PileOption.DISCARD:
		if card:
			var card_instance = CardInstance.new(card)
			_context.get_player().cards.shuffle_card_into_discard_pile(card_instance)
	elif pile == PileOption.DRAW:
		if card:
			var instance = CardInstance.new(card)
			_context.get_player().cards.add_card_to_draw_pile(instance, true)
		else:
			_context.get_player().cards.draw_cards(1)
	await _context.battle_field.get_tree().create_timer(0.15).timeout
