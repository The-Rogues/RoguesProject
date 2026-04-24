extends Action
class_name RemoveCardsByNameAction

@export var _name:String


func execute(_context:BattleContext = null, _user:AbstractEntity = null):
	_context.get_player().cards.remove_hand_cards_by_name(_name)
