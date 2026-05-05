extends Action
class_name DrawCardAction

@export var amount: int

func execute(_context:BattleContext = null, _user:AbstractEntity = null):
	_context.get_player().cards.draw_cards(amount)
