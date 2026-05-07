extends Action
class_name ShufflePileAction

@export var is_draw: bool

# Called when the node enters the scene tree for the first time.
func execute(_context:BattleContext = null, _user:AbstractEntity = null) -> void:
	if is_draw:
		_context.get_player().cards.draw_pile.shuffle()
	else:
		_context.get_player().cards.discard_pile.shuffle()
