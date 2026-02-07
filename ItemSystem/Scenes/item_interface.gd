extends Container
class_name ItemInterface

signal activate_item(index:int)
@export var override_item_datas:Array[ItemData]
@export var item_slots:Array[ItemSlotUI]
@export var minimum_item_slot_count:int = 3
@export var force_initialize:bool = false
@export var is_shop_interface:bool = false
@export var sell_items:bool = false

const ITEM_UI = preload("res://ItemSystem/Scenes/item_slot_ui.tscn")

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
	
	for i in range(0, minimum_item_slot_count):
		var item_slot:ItemSlotUI = ITEM_UI.instantiate()
		add_child(item_slot)
		item_slots.append(item_slot)
	
	for i in range(0, items.size()):
		if i >= minimum_item_slot_count or minimum_item_slot_count == 0:
			var new_item_slot:ItemSlotUI = ITEM_UI.instantiate()
			add_child(new_item_slot)
			new_item_slot.item_price = items[i].shop_price
			new_item_slot.is_shop_item = is_shop_interface
			item_slots.append(new_item_slot)
			if sell_items:
				new_item_slot.display_sell_price = true
		var item_slot = get_child(i)
		
		item_slot.initialize(items[i], i)
		item_slot.clicked.connect(_on_item_clicked)
		item_slot.activated.connect(_on_item_activate)
	pass

func clear_item_slots():
	for child in get_children():
		child.queue_free()
		item_slots.clear()
		await get_tree().process_frame
	
	for i in range(0, minimum_item_slot_count):
		var item_slot:ItemSlotUI = ITEM_UI.instantiate()
		add_child(item_slot)
		item_slots.append(item_slot)

func set_item_to_bought(index:int):
	item_slots[index].set_to_bought()

func _on_item_clicked(index:int):
	for child in get_children():
		if child.index != index:
			child.contents.visible = false

func _on_item_activate(index:int):
	activate_item.emit(index)
