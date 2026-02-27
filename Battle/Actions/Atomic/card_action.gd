extends BattleAction
class_name CardAction
## An action that operates on the player's deck in a battle. Does not effect
## the persistent deck that is loaded between scenes.
##
## Includes options for drawing a random card from a specified pile, adding
## a completely new card to the play deck, or requesting the battle to use
## a pop options panel where the player can select a specific card from a deck.

enum DrawMode {DRAW_RANDOM, DRAW_NEW, DRAW_CHOICE}
enum DeckOption {DRAW_PILE, DISCARD_PILE, WHOLE_DECK}
@export var draw_mode:DrawMode
## Used when draw mode is Draw Random or Draw New. Sets how many times a card
## is drawn into the deck.
@export var draw_count:int = 1
@export var deck_choice:DeckOption
## Used when draw mode is set to Draw Choice. The referenced card will be added
## to the specified deck in deck option.
@export var draw_card:CardData


func _execute(battle_instance:BattleManager, _action_user:BattleEntity = null):
	match draw_mode:
		DrawMode.DRAW_RANDOM:
			## Action is atomic, so if the draw pile is empty, cards are
			## immedietly reshuffled back into draw pile so operation completes
			if battle_instance.battle_card_manager.draw_pile.cards.is_empty():
				battle_instance.reshuffle_deck()
			battle_instance.draw_card(draw_count)
		DrawMode.DRAW_NEW:
			battle_instance.battle_card_manager.draw_card(draw_count, draw_card)
		DrawMode.DRAW_CHOICE:
			var deck:CardDeck
			if deck_choice == DeckOption.DRAW_PILE:
				battle_instance.battle_card_manager.reshuffle_deck()
				deck = battle_instance.battle_card_manager.draw_pile
			elif deck_choice == DeckOption.DISCARD_PILE:
				deck = battle_instance.battle_card_manager.discard_pile
			elif deck_choice == DeckOption.WHOLE_DECK:
				deck = battle_instance.battle_card_manager.deck
			
			battle_instance.battle_card_manager.deck_card_selector.query_and_display(
				deck
			)
