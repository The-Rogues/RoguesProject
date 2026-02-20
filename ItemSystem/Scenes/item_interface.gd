extends Container
class_name ItemInterface

signal activate_item(index:int)
@export var override_item_datas:Array[ItemData]
@export var item_slots:Array[ItemSlotUI]
@export var minimum_item_slot_count:int = 3
@export var force_initialize:bool = false

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
		create_item_slot(items[i], i)
	pass

func create_item_slot(item_data:ItemData, index:int):
	if index >= minimum_item_slot_count or minimum_item_slot_count == 0:
		var item_slot:ItemSlotUI = ITEM_UI.instantiate()
		add_child(item_slot)
		item_slots.append(item_slot)
	var item_slot = get_child(index)
	
	item_slot.initialize(item_data, index)
	item_slot.clicked.connect(_on_item_clicked)
	item_slot.activated.connect(_on_item_activate)


func clear_item_slots(keep_slots:bool = false):
	for child in get_children():
		child.queue_free()
		item_slots.clear()
		await get_tree().process_frame
	
	if not keep_slots:
		return
	
	for i in range(0, minimum_item_slot_count):
		var item_slot:ItemSlotUI = ITEM_UI.instantiate()
		add_child(item_slot)
		item_slots.append(item_slot)

func _on_item_clicked(index:int):
	for child in get_children():
		if child.index != index:
			child.contents.visible = false

func _on_item_activate(index:int):
	activate_item.emit(index)
