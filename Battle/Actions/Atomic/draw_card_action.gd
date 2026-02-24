extends BattleAction
class_name DrawCardAction

@export var draw_count:int

func _execute(battle_instance:BattleManager, action_user:BattleEntity):
	var drawn_cards = battle_instance.draw_pile.draw_cards(draw_count)
	for card in drawn_cards:
		battle_instance.player_card_hand.draw_card(card)
