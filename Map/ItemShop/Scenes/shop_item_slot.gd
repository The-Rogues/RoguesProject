extends Control
class_name ShopItemSlot

signal started_transaction(index:int)

enum TransactionType {BUY, SELL}
@export var transaction_type:TransactionType
@export var display_price:int = 100

@onready var item_texture_rect: TextureRect = $VBoxContainer/ItemIcon/Item
@export var price_label:Label
@onready var elements: VBoxContainer = $VBoxContainer/Elements
@onready var context_panel:ContextPanel = $VBoxContainer/Elements/ContextPanel
@onready var transaction_label:Label = $VBoxContainer/Elements/Activate/TransactionLabel
@onready var sell_status_label:Label = $SellStatusLabel
@onready var item_icon_button: TextureButton = $VBoxContainer/ItemIcon

var transaction_completed:bool = false
var index:int

func _ready() -> void:
	item_texture_rect.visible = false
	elements.visible = false
	price_label.text = str(display_price) + "G"
	
	item_icon_button.disabled = true

func initialize(item_data:ItemData, new_index:int):
	var information:String = item_data.name + "\n" + item_data.description
	context_panel.set_context(information)
	item_texture_rect.texture = item_data.display_texture
	item_texture_rect.visible = true
	item_icon_button.disabled = false
	
	if transaction_type == TransactionType.BUY:
		price_label.text = str(item_data.shop_price) + "G"
		transaction_label.text = "Buy"
	elif transaction_type == TransactionType.SELL:
		price_label.text = str(item_data.sell_price) + "G"
		transaction_label.text = "Sell"
	
	index = new_index

func confirm_transaction():
	item_icon_button.disabled = true
	sell_status_label.visible = true
	price_label.visible = false
	item_texture_rect.visible = false

func _on_item_slot_clicked() -> void:
	elements.visible = !elements.visible
	pass # Replace with function body.


func _on_try_transaction_button() -> void:
	started_transaction.emit(index)
	pass # Replace with function body.
