extends BattleAction
class_name CardAction

enum DrawMode {DRAW_RANDOM, DRAW_NEW, DRAW_CHOICE}
enum Deck {DRAW_PILE, DISCARD_PILE, WHOLE_DECK}
@export var draw_mode:DrawMode
@export_group("Random Draw Options")
@export var draw_count:int = 1
@export_group("Draw Choice Options")
@export var deck_choice:Deck
@export_group("Draw New Options")
@export var draw_card:CardData


func _execute(battle_instance:BattleManager, _action_user:BattleEntity = null):
	match draw_mode:
		DrawMode.DRAW_RANDOM:
			battle_instance.reshuffle_deck()
			battle_instance.draw_card(draw_count)
		DrawMode.DRAW_NEW:
			battle_instance.battle_card_manager.draw_card(1, draw_card)
		DrawMode.DRAW_CHOICE:
			var deck:CardDeck
			if deck_choice == Deck.DRAW_PILE:
				battle_instance.battle_card_manager.reshuffle_deck()
				deck = battle_instance.battle_card_manager.draw_pile
			elif deck_choice == Deck.DISCARD_PILE:
				deck = battle_instance.battle_card_manager.discard_pile
			elif deck_choice == Deck.WHOLE_DECK:
				deck = battle_instance.battle_card_manager.deck
			
			battle_instance.battle_card_manager.deck_card_selector.query_and_display(
				deck
			)
