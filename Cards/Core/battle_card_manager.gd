extends Control
class_name BattleCardManager

signal opened_deck_view
signal closed_deck_view
signal played_card(card:CardData)
signal try_play_card(card:CardUI)
signal card_drawn(card:CardData)
signal card_instance_drawn(card:CardInstance)

@onready var discard_pile_button: VBoxContainer = $DiscardPile
@onready var draw_pile_button: VBoxContainer = $Drawpile

@onready var deck_card_selector: DeckCardSelector = $DeckCardSelector
@onready var draw_pile_viewer: CardDeckViewerUI = $DrawPileViewer
@onready var discard_pile_viewer: CardDeckViewerUI = $DiscardPileViewer
@onready var draw_pile_size: Label = $DrawPileSize
@onready var discard_pile_size: Label = $DiscardPileSize


@export var card_hand:CardPlayHand
@export var card_deck:CardDeck

var deck:CardDeck
var draw_pile: CardDeck
var discard_pile: CardDeck
var permanant_discard: CardDeck

var battle:BattleManager
var player:BattleEntity

#func _ready() -> void:
	#if card_deck:
		#initialize(card_deck)


func initialize(starting_card_deck:CardDeck, player:BattleEntity, battle:BattleManager):
	self.player = player
	self.battle = battle
	
	deck = starting_card_deck.duplicate()
	draw_pile = starting_card_deck.duplicate(true)
	discard_pile = CardDeck.new()
	permanant_discard = CardDeck.new()
	
	discard_pile.name = "Discard Pile"
	draw_pile.name = "Draw Pile"
	
	draw_pile.cards.shuffle()
	
	draw_pile_viewer._initialize(draw_pile)
	discard_pile_viewer._initialize(discard_pile)
	deck_card_selector.selected_card.connect(_on_selected_card)
	
	discard_pile_viewer.closed.connect(_on_pile_closed)
	draw_pile_viewer.closed.connect(_on_pile_closed)
	discard_pile_viewer.opened.connect(_on_pile_viewed)
	draw_pile_viewer.opened.connect(_on_pile_viewed)
	card_hand.play_card.connect(_try_to_play_card)
	card_hand.card_drawn.connect(_on_hand_draw)
	
	
	draw_pile.deck_updated.connect(on_pile_updated)
	discard_pile.deck_updated.connect(on_pile_updated)


func _on_hand_draw(instance:CardInstance):
	instance.player = player
	player.status_conditions.changed.connect(instance.update_instance)
	instance.update_instance()
	card_instance_drawn.emit(instance)


func on_pile_updated(updated_cards:Array[CardData]):
	draw_pile_size.text = str(draw_pile.cards.size())
	discard_pile_size.text = str(discard_pile.cards.size())


func _on_pile_viewed():
	discard_pile_button.visible = false
	draw_pile_button.visible = false
	opened_deck_view.emit()


func _on_pile_closed():
	discard_pile_button.visible = true
	draw_pile_button.visible = true
	closed_deck_view.emit()
	pass


func _on_selected_card(card_data:CardData, deck:CardDeck):
	deck.remove_card(card_data)
	card_hand.draw_card(card_data)


func _try_to_play_card(card:CardUI):
	try_play_card.emit(card)


func hide_hand(hide:bool = true):
	card_hand.visible = hide


func reject_play():
	card_hand.reject_play()


func play_card(card:CardUI):
	card_hand.confirm_play(card)
	if card.card_instance.data.discard_after_play:
		permanant_discard.add_card(card.card_instance.data)
	else:
		discard_pile.add_card(card.card_instance.data)
	played_card.emit(card.card_instance.data)


func draw_card(draw_count:int = 1, card:CardData = null):
	if card:
		for i in range(0, draw_count):
			card_hand.draw_card(card)
			card_drawn.emit(card)
	else:
		var cards = draw_pile.draw_cards(draw_count)
		for drawn_card in cards:
			if drawn_card != null:
				card_hand.draw_card(drawn_card)
				card_drawn.emit(drawn_card)


func transfer_hand_to_discard():
	for card in card_hand.card_uis:
		discard_pile.add_card(card.card_data)
	card_hand.clear_hand()


func reshuffle_deck():
	if draw_pile.cards.size() < 5 and deck.cards.size() > 5:
		print("reshuffle")
		discard_pile.transfer_cards_to_deck(draw_pile, true)
