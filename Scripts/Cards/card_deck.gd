class_name CardDeck
extends Resource

@export var deck:Array[CardData]

func draw(amount:int):
	if amount > deck.size():
		return
	
	var card_draw:Array[CardData]
	for i in range(amount):
		var ran = range(0, deck.size())
		card_draw.append(deck.pop_at(ran))

func remove_card_from_deck(card_data:CardData):
	if deck.has(card_data):
		deck.erase(card_data)

func add_card_to_deck(card_data:CardData):
	deck.append(card_data)
