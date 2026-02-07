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
signal deck_updated(updated_cards:Array[CardData])
##Card storage

func draw_random_card():
	var card_array:Array[CardData] = get_deck_as_array()
	if card_array.is_empty():
		return null
	var picked_card = card_array.pick_random()
	if(picked_card != null):
		cards[picked_card] -= 1
	deck_updated.emit(get_deck_as_array())
	return picked_card

## Use for displaying cards for deck viewer or playing hand
func get_deck_as_array():
	var card_array:Array[CardData]
	for card_data in cards:
		var card_count:int = cards[card_data]
		for i in range(0, card_count):
			card_array.append(card_data)
	return card_array
	#get data from dictionary & put into array. 

func add_card(card_data:CardData):
	if cards.has(card_data):
		cards[card_data] += 1
	else:
		cards[card_data] = 1
	deck_updated.emit(get_deck_as_array())

func remove_card(card_data:CardData):
	if cards.has(card_data):
		cards[card_data] -= 1
	deck_updated.emit(get_deck_as_array())

## Use to create new deck for initialization
func set_deck(new_card_datas:Array[CardData]):
	cards.clear()
	for card_data in new_card_datas:
		add_card(card_data)



#function to transfer some card items into another deck 
func copy_to_this_deck(card_deck:CardDeck):
	var cards:Array[CardData] = card_deck.get_deck_as_array()
	card_deck.cards.clear()
	
	for card in cards:
		add_card(card)
	deck_updated.emit(get_deck_as_array())
	
	
func draw_mult_array(draw_amount:int):
	#this is the logic to check if the deck is empty?
	
	var drawn_cards:Array[CardData] = []
	for i in range(draw_amount):
		if cards.is_empty():
			
			#next up is to emit signal to change the battle scene
			break
		drawn_cards.append(draw_random_card())
		
	return drawn_cards

#return an array of cards + for loop to add random card
	
	
	
	
	
	
	
	
	
	
