# ==========================================================
# Authors: Fabian, Andy 
# Description:
#   An editable resource that stores a set of card datas
#   and how many of that card are in a deck.
#   To be used as a creatable standalone asset in editor.
#
# ==========================================================

class_name CardDeck
extends Resource
# signals when cards are added or removed from the deck
signal deck_updated(updated_cards:Array[CardData])
## Used in DeckViewerUI to indicate the kind of deck being viewed
@export var name:String
## The cards stored in the deck
## Key field is a card type and value field is the number of that 
## card type in the deck
@export var cards:Array[CardData]

func get_sorted_cards():
	if cards.is_empty():
		return
	var sorted_cards:Array[CardData] = cards.duplicate(true)
	sorted_cards.sort()
	return sorted_cards

func add_card(card_data:CardData) -> void:
	cards.append(card_data)
	deck_updated.emit(cards)

## Use to create new deck for initialization
func add_cards(new_card_datas:Array[CardData]) -> void:
	for card_data in new_card_datas:
		cards.append(card_data)
	deck_updated.emit(cards)

func remove_card(card_data:CardData) -> void:
	cards.erase(card_data)
	deck_updated.emit(cards)

## Moves all stored card datas to another deck
func transfer_cards_to_deck(
		target_card_deck:CardDeck, 
		shuffle:bool = false,
):
	
	target_card_deck.cards = cards.duplicate(true)
	
	# Remove cards from this deck
	cards.clear()
	if shuffle:
		target_card_deck.cards.shuffle()
	# signal this deck was updated and is now empty
	deck_updated.emit(cards)

## Pops a random card from the deck
func draw_card() -> CardData:
	if cards.is_empty():
		return
	
	var picked_card:CardData = cards.pop_front()
	deck_updated.emit(cards)
	return picked_card

## Returns an array of randomly drawn cards from the deck
## Drawn cards are removed from the deck
func draw_cards(draw_amount:int) -> Array[CardData]:
	var drawn_cards:Array[CardData] = []
	for i in range(draw_amount):
		# Break if deck has run out of cards
		if cards.is_empty():
			break
		
		drawn_cards.append(draw_card())
	return drawn_cards
