extends Node
class_name CardHandler

signal drew_card(card:CardInstance)
signal discard_pile_updated(cards:CardInstance)
signal draw_pile_updated(cards:CardInstance)


var draw_pile:Array[CardInstance]
var discard_pile:Array[CardInstance]
var exhaust_pile:Array[CardInstance]
var drawn_cards:Array[CardInstance]


func initialize(deck:Array[CardData], player:PlayerEntity):
	for card_data in deck:
		var instance = CardInstance.new(card_data)
		draw_pile.append(instance)
		
		# TODO: Inefficient, look into updating card instance only when relevent
		player.effects.effect_changed.connect(instance.update_instance)
	
	draw_pile.shuffle()


func draw_cards(amount: int):
	if draw_pile.size() < amount:
		discard_pile.shuffle()
		draw_pile.append_array(discard_pile)
		discard_pile.clear()
	
	var cards_drawn := 0
	
	while !draw_pile.is_empty() and cards_drawn < amount:
		var card = draw_pile.pop_front()
		drawn_cards.append(card)
		drew_card.emit(card)
		
		cards_drawn += 1
	
	discard_pile_updated.emit(discard_pile)
	draw_pile_updated.emit(draw_pile)


func exhaust_card(card:CardInstance, from:Array[CardInstance]):
	if from.has(card):
		exhaust_pile.append(card)
		from.erase(card)


func add_card_to_draw_pile(card:CardInstance, front:bool = false):
	if front:
		draw_pile.push_front(card)
	else:
		draw_pile.append(card)
	
	draw_pile_updated.emit(draw_pile)


func discard_card(card: CardInstance):
	# Ensure no duplicates in discard
	if discard_pile.has(card):
		discard_pile.erase(card)
	
	discard_pile.append(card)
	discard_pile_updated.emit(discard_pile)


func move_drawn_card_into_discard_pile(instance:CardInstance):
	if drawn_cards.has(instance):
		if not instance.data.exhaust_after_play:
			discard_pile.append(instance)
			#TODO: Add to discard pile
		drawn_cards.erase(instance)
		
		discard_pile_updated.emit(discard_pile)


func shuffle_card_into_discard_pile(instance:CardInstance):
	var random_index = randi() % (discard_pile.size() + 1)
	discard_pile.insert(random_index, instance)
	discard_pile_updated.emit(discard_pile)


func move_draw_into_discard_pile():
	discard_pile.append_array(drawn_cards)
	drawn_cards.clear()
	
	discard_pile_updated.emit(discard_pile)


func reshuffle_into_drawpile():
	discard_pile.shuffle()
	draw_pile.append_array(discard_pile)
	discard_pile.clear()
