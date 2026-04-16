extends Action
class_name AddCardToDiscardPileAction

@export var card:CardData


func execute(_context:BattleContext = null, _user:AbstractEntity = null):
	var card_instance = CardInstance.new(card)
	_context.get_player().cards.shuffle_card_into_discard_pile(card_instance)
	await _context.battle_field.get_tree().create_timer(0.15).timeout
