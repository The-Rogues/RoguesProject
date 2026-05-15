extends Container
class_name ItemInterface

signal use_item(index:int, item_slot:ItemSlot)
signal discard_item(index:int, item_slot:ItemSlot)

@export var minimum_item_slot_count:int = 3

const Item_Slot = preload("res://item_system/scenes/item_slot.tscn")


func _process(delta: float) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) or \
			Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		_on_slot_clicked(-1)
		pass


func populate_item_slots(items:Array[ItemData], in_battle:bool = false):
	for child in get_children():
		child.queue_free()
	
	var slot_count:int = 0
	for i in range(0, items.size()):
		var item_slot:ItemSlot = Item_Slot.instantiate()
		add_child(item_slot)
		item_slot.initialize(items[i], slot_count)
		item_slot.clicked.connect(_on_slot_clicked)
		item_slot.used.connect(_on_use_item)
		item_slot.discard.connect(_on_discard_item)
		slot_count += 1
		
		if !items[i].usable_out_of_battle and !in_battle or items[i] is KeyItem:
			item_slot.use_button.disabled = true
		else:
			item_slot.use_button.disabled = false
	
	while slot_count < minimum_item_slot_count:
		var item_slot:ItemSlot = Item_Slot.instantiate()
		add_child(item_slot)
		slot_count += 1
	
	var all_slots: Array[Node] = get_children()
	all_slots[all_slots.size() - 1].color_item_slot()


func add_slot():
	var all_slots: Array[Node] = get_children()
	all_slots[all_slots.size() - 1].uncolor_item_slot()
	var item_slot:ItemSlot = Item_Slot.instantiate()
	item_slot.color_item_slot()
	add_child(item_slot)


func _on_use_item(index:int, item_slot:ItemSlot):
	use_item.emit(index, item_slot)


func _on_discard_item(index:int, item_slot:ItemSlot):
	discard_item.emit(index, item_slot)


func _on_slot_clicked(index:int):
	for child in get_children():
		if child.index != index:
			child.contents.visible = false
