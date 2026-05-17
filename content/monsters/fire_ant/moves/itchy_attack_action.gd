extends AttackAction
class_name ItchyAttackAction

func execute(_context:BattleContext = null, _user:AbstractEntity = null):
	var num_in_draw: int = _context.get_player().cards.get_draw_cards_by_name("Itchy").size()
	var num_in_discard: int = _context.get_player().cards.get_discard_cards_by_name("Itchy").size()
	hits = num_in_draw + num_in_discard
	await super(_context, _user)
