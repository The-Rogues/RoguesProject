extends Control
class_name ShopItemSlot

signal clicked(index:int)
signal selected(index:int, transaction_completed:bool)

enum TransactionType {BUY, SELL}
@export var transaction_type:TransactionType
@onready var item_texture_rect: TextureRect = $VBoxContainer/ItemIcon/Item
@onready var sell_status_label: Label = $SellStatusLabel
@onready var price_label: Label = $VBoxContainer/PriceLabel
@onready var item_icon: TextureButton = $VBoxContainer/ItemIcon
@onready var contents: Control = $Debug

var transaction_completed:bool = false
var index:int

func _ready() -> void:
	item_texture_rect.visible = false

func initialize(item_data:ItemData, new_index:int, transaction_type:int):
	item_texture_rect.texture = item_data.display_texture
	item_texture_rect.visible = true
	sell_status_label.visible = false
	
	if transaction_type == 0:
		price_label.text = str(item_data.shop_price)
	else:
		price_label.text = str(item_data.sell_price)
	
	index = new_index

func _on_item_slot_clicked() -> void:
	clicked.emit(index)
	selected.emit(index, transaction_completed)
	pass # Replace with function body.

func confirm_transaction():
	item_texture_rect.visible = false
	sell_status_label.visible = true
	transaction_completed = true
	item_icon.disabled = true
