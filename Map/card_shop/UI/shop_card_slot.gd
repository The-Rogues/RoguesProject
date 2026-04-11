extends Control
class_name ShopCardSlot

signal selected(index:int, transaction_completed:bool)

@onready var card_ui: CardUI = $VBoxContainer/CardUI
@onready var cost_label: Label = $VBoxContainer/CostLabel
@onready var sold_label: Label = $SoldLabel

var transaction_completed: bool = false
var index: int

func _ready() -> void:
	if sold_label:
		sold_label.visible = false

	if card_ui:
		card_ui.clicked.connect(_on_card_ui_clicked)

func initialize(card_data: CardData, new_index: int, transaction_type: int) -> void:
	index = new_index
	transaction_completed = false

	if sold_label:
		sold_label.visible = false

	if card_ui:
		card_ui.set_card_data(card_data)

	if cost_label:
		cost_label.text = str(card_data.shop_price)

func confirm_transaction() -> void:
	transaction_completed = true

	if sold_label:
		sold_label.visible = true

	if card_ui:
		card_ui.mouse_filter = Control.MOUSE_FILTER_IGNORE

	modulate.a = 0.6

func _on_card_ui_clicked(_card: CardUI) -> void:
	selected.emit(index, transaction_completed)
