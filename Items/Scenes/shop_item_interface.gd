extends ItemInterface
class_name ShopItemInterface

signal selected_item(index:int, transaction_type:int, transaction_completed:bool)
const SHOP_ITEM_SLOT = preload("res://Map/Shop/UI/shop_item_slot.tscn")

@export var shop_item_slots:Array[ShopItemSlot]

enum TransactionType {BUY, SELL}
@export var transaction_type:TransactionType

func _ready() -> void:
	if force_initialize:
		initialize(override_item_datas)


func initialize(items:Array[ItemData]):
	if items.is_empty():
		return
	
	for child in get_children():
		child.queue_free()
		shop_item_slots.clear()
		await get_tree().process_frame
	
	for i in range(0, items.size()):
		create_shop_item_slot(items[i], i)
	pass


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
