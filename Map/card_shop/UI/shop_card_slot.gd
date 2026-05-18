extends Control
class_name ShopCardSlot

signal selected(index:int, transaction_completed:bool)

@onready var card_ui: Card = $VBoxContainer/CardUI
@onready var cost_label: Label = $VBoxContainer/CostLabel
@onready var sold_label: Label = $SoldLabel

var transaction_completed: bool = false
var index: int
var transaction_type: int

func _ready() -> void:
	if sold_label:
		sold_label.visible = false

	if card_ui:
		card_ui.interaction_mode = true
		card_ui.clicked.connect(_on_card_ui_clicked)

func initialize(card_data: CardInstance, new_index: int, new_transaction_type: int) -> void:
	index = new_index
	transaction_completed = false
	transaction_type = new_transaction_type

	if sold_label:
		sold_label.visible = false

	if card_ui:
		card_ui.initialize(card_data)
	
	if transaction_type == ShopCardInterface.TransactionType.BUY:
		if cost_label:
			cost_label.text = str(card_data.data.shop_price)
	else:
		if cost_label:
			cost_label.text = str(card_data.data.transform_price)

func confirm_transaction() -> void:
	transaction_completed = true

	# Only show SOLD label for buying
	if transaction_type == ShopCardInterface.TransactionType.BUY:
		if sold_label:
			sold_label.visible = true

		if card_ui:
			card_ui.mouse_filter = Control.MOUSE_FILTER_IGNORE

		modulate.a = 0.6
	else:
		queue_free()

func _on_card_ui_clicked(_card: Card) -> void:
	selected.emit(index, transaction_completed)
