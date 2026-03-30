# ==========================================================
# Authors: Andy, Fabian 
# Description:
#   Scripting behaviour for the DeckViewer scene
#   Connects to a card deck's update signal and updates
#   display that shows all cards in a deck
#
# ==========================================================

extends PanelContainer
class_name CardDeckViewerUI

signal opened
signal closed
## The button in the scene that will open the deck viewer
@export var activation_button:TextureButton
@onready var deck_name: Label = $VBoxContainer/Panel/PanelContainer/DeckName
@onready var card_container: FlowContainer = $VBoxContainer/MarginContainer/ScrollContainer/CardConatiner
@onready var empty_label: Label = $VBoxContainer/MarginContainer/EmptyLabel

const CARD_UI = preload("res://Cards/UI/card.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if activation_button:
		visible = false
		activation_button.button_up.connect(_on_activation_button_up)

func _initialize(card_deck:CardDeck):
	for child in card_container.get_children():
		child.queue_free()
	
	deck_name.text = card_deck.name
	card_deck.deck_updated.connect(_update_card_display)
	_update_card_display(card_deck.cards)


func _update_card_display(new_card_datas:Array[CardData]):
	for child in card_container.get_children():
		child.queue_free()
	
	empty_label.visible = new_card_datas.is_empty()
	
	for card_data in new_card_datas:
		var new_card_ui:CardUI = CARD_UI.instantiate()
		card_container.add_child(new_card_ui)
		new_card_ui.check_for_play_area = false
		new_card_ui.set_card_data(card_data)
		new_card_ui.check_for_play_area = false


func _on_activation_button_up():
	
	opened.emit()
	visible = true

func _on_close_button_up() -> void:
	closed.emit()
	visible = false
	pass # Replace with function body.
