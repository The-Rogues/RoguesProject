extends ItemInterface
class_name ShopItemInterface

const SHOP_ITEM_SLOT = preload("res://Map/ItemShop/Scenes/shop_item_slot.tscn")

enum TransactionType {BUY, SELL}
@export var transaction_type:TransactionType

func _ready() -> void:
	if force_initialize:
		initialize(override_item_datas)

func _process(delta: float) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) or \
			Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		_on_item_clicked(-1)
		pass

func initialize(items:Array[ItemData]):
	if items.is_empty():
		return
	
	for child in get_children():
		child.queue_free()
		item_slots.clear()
		await get_tree().process_frame
	
	for i in range(0, items.size()):
		create_shop_item_slot(items[i], i)
	pass


func create_shop_item_slot(item_data:ItemData, index:int):
	var shop_slot:ShopItemSlot = SHOP_ITEM_SLOT.instantiate()
	add_child(shop_slot)
	var type = transaction_type as int
	shop_slot.transaction_type = type
	shop_slot.initialize(item_data, index)
	item_slots.append(shop_slot)
	shop_slot.clicked.connect(_on_item_clicked)
	shop_slot.activated.connect(_on_item_activate)


func confirm_transaction(index:int):
	item_slots[index].confirm_transaction()
