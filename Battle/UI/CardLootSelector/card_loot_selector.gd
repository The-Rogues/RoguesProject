extends PanelContainer
class_name CardLootSelector

@onready var header: Label = $VBoxContainer/HeaderMargin/VBoxContainer/Header
@onready var card_container: HBoxContainer = $VBoxContainer/MarginContainer/CardContainer

signal skipped
signal selected_card(card_data:CardData)
const CARD_UI = preload("res://Cards/UI/card.tscn")

@export var header_title:String
@export var cards:Array[CardData]


func _ready() -> void:
	if cards:
		initialize(cards, header_title)


func initialize(loot_cards:Array[CardData], draw_title:String):
	for child in card_container.get_children():
		child.queue_free()
	
	for card_data in loot_cards:
		var card = CARD_UI.instantiate()
		card_container.add_child(card)
		card.set_card_data(card_data)
		card.clicked.connect(_on_card_selected)
		card.hovered.connect(_on_card_hovered)
	
	visible = true
	header.text = draw_title


func _on_card_hovered(card: CardUI, hovering: bool) -> void:
	card.blow_up(hovering)


func _on_card_selected(card:CardUI):
	selected_card.emit(card.card_data)
	visible = false
	pass


func _on_skip_button_selected() -> void:
	visible = false
	skipped.emit()
	pass # Replace with function body.
