extends FlowContainer
class_name ShopItemInterface

signal selected_item(index:int, transaction_type:int, transaction_completed:bool)
const SHOP_ITEM_SLOT = preload("res://Map/Shop/UI/shop_item_slot.tscn")

@export var shop_item_slots:Array[ShopItemSlot]
@export var minimum_item_slot_count:int = 8

enum TransactionType {BUY, SELL}
@export var transaction_type:TransactionType


func initialize(items:Array[ItemData]):
	if items.is_empty():
		for i in range(0, minimum_item_slot_count):
			var item_slot:ShopItemSlot = SHOP_ITEM_SLOT.instantiate()
			add_child(item_slot)
		return
	
	for child in get_children():
		child.queue_free()
	
	var slot_count:int = 0
	for i in range(0, items.size() - 1):
		create_shop_item_slot(items[i], i)
		slot_count += 1
	
	while slot_count < minimum_item_slot_count:
		var item_slot:ShopItemSlot = SHOP_ITEM_SLOT.instantiate()
		add_child(item_slot)
		slot_count += 1


func create_shop_item_slot(item_data:ItemData, index:int):
	var shop_slot:ShopItemSlot = SHOP_ITEM_SLOT.instantiate()
	add_child(shop_slot)
	shop_slot.initialize(item_data, index, transaction_type)
	
	shop_item_slots.append(shop_slot)
	shop_slot.selected.connect(_on_item_selected)


func _on_item_selected(index:int, transaction_completed:bool):
	selected_item.emit(index, transaction_type, transaction_completed)


func confirm_transaction(index:int):
	shop_item_slots[index].confirm_transaction()
