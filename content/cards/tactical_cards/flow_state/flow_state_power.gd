extends BattlePower
class_name FlowStatePower

var agile_shot: CardData = preload("res://content/cards/tactical_cards/reload/agile_shot.tres")

func on_apply(_context:BattleContext):
	pass

func on_turn_entered(_context:BattleContext):
	var agile_shot_instance: CardInstance = CardInstance.new(agile_shot)
	_context.get_player().cards.add_card_to_draw_pile(agile_shot_instance, true)
	_context.get_player().cards.draw_cards(1)
