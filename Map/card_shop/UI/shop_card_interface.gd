extends Control
class_name ShopCardInterface

signal selected_card(index:int, transaction_type:int, transaction_completed:bool)

const SHOP_CARD_SLOT = preload("res://Map/card_shop/UI/shop_card_slot.tscn")

@export var shop_card_slots:Array[ShopCardSlot]

enum TransactionType { BUY, TRANSFORM }
@export var transaction_type:TransactionType


func initialize(cards: Array) -> void:
	clear_card_slots()

	if cards.is_empty():
		return

	for i in range(cards.size()):
		create_shop_card_slot(cards[i], i)


func clear_card_slots() -> void:
	for child in get_children():
		child.queue_free()

	shop_card_slots.clear()
	await get_tree().process_frame


func create_shop_card_slot(card_data:CardInstance, index:int) -> void:
	var shop_slot:ShopCardSlot = SHOP_CARD_SLOT.instantiate()
	add_child(shop_slot)
	shop_slot.initialize(card_data, index, transaction_type)

	shop_card_slots.append(shop_slot)
	shop_slot.selected.connect(_on_card_selected)


func _on_card_selected(index:int, transaction_completed:bool) -> void:
	selected_card.emit(index, transaction_type, transaction_completed, self)


func confirm_transaction(index:int) -> void:
	if index < 0 or index >= shop_card_slots.size():
		return
	shop_card_slots[index].confirm_transaction()
