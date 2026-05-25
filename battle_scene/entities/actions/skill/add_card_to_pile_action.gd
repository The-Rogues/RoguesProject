extends Action
class_name AddCardToPileAction

enum PileOption {DISCARD, DRAW}
@export var card:CardData
@export var pile:PileOption = PileOption.DISCARD
@export var count: int = 1
@export var shuffle: bool = true

func execute(_context:BattleContext = null, _user:AbstractEntity = null):
	for i in range(0, count):
		if pile == PileOption.DISCARD:
			if card:
				var card_instance = CardInstance.new(card)
				_context.get_player().cards.shuffle_card_into_discard_pile(card_instance)
				if shuffle:
					_context.get_player().cards.discard_pile.shuffle()
		elif pile == PileOption.DRAW:
			if card:
				var instance = CardInstance.new(card)
				_context.get_player().cards.add_card_to_draw_pile(instance, true)
				if shuffle:
					_context.get_player().cards.draw_pile.shuffle()
			else:
				_context.get_player().cards.draw_cards(1)
				await _context.battle_field.get_tree().create_timer(0.25).timeout
	await _context.battle_field.get_tree().create_timer(0.15).timeout
