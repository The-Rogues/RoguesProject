extends PanelContainer
class_name DeckCardSelector

signal selected_card(card_data:CardData, deck:CardDeck)
signal opened
## The button in the scene that will open the deck viewer
@onready var card_container: FlowContainer = $VBoxContainer/MarginContainer/ScrollContainer/CardConatiner
@onready var empty_label: Label = $VBoxContainer/MarginContainer/EmptyLabel
var queried_deck:CardDeck

const CARD_UI = preload("res://Cards/UI/card.tscn")

func query_and_display(card_deck:CardDeck):
	queried_deck = card_deck
	for child in card_container.get_children():
		child.queue_free()
	
	for card_data in card_deck.cards:
		var card = CARD_UI.instantiate()
		card_container.add_child(card)
		card.set_card_data(card_data)
		card.clicked.connect(_on_card_selected)
		card.hovered.connect(_on_card_hovered)
	
	empty_label.visible = card_deck.cards.is_empty()
	
	opened.emit()
	visible = true


func _on_card_hovered(card: CardUI, hovering: bool) -> void:
	card.blow_up(hovering)


func _on_card_selected(card:CardUI):
	selected_card.emit(card.card_data)
	visible = false
	pass


func _on_cancel_button_up() -> void:
	visible = false
	pass # Replace with function body.
