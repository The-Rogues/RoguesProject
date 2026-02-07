# ==========================================================
# Author: Fabian 
# Description:
#   An editable resource that stores a set of card datas
#   and how many of that card are in a deck.
#   To be used as a creatable standalone asset in editor.
#
# ==========================================================

class_name CardDeck
extends Resource

@export var cards:Dictionary[CardData, int]

func draw_random_card():
	var card_array:Array[CardData] = get_deck_as_array()
	return card_array.pick_random()

## Use for displaying cards for deck viewer or playing hand
func get_deck_as_array():
	var card_array:Array[CardData]
	for card_data in cards:
		var card_count:int = cards[card_data]
		for i in range(0, card_count):
			card_array.append(card_data)
	return card_array

func add_card(card_data:CardData):
	if cards.has(card_data):
		cards[card_data] += 1
	else:
		cards[card_data] = 1

func remove_card(card_data:CardData):
	if cards.has(card_data):
		cards[card_data] -= 1

## Use to create new deck for initialization
func set_deck(new_card_datas:Array[CardData]):
	cards.clear()
	for card_data in new_card_datas:
		add_card(card_data)
