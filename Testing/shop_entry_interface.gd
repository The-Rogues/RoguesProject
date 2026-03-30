extends PanelContainer
class_name ShopEntryInterface

signal entry_selected(data:ShopEntryData)
signal entry_hovered(data:ShopEntryData)


const SHOP_ENTRY = preload("res://Testing/shop_entry.tscn")
@onready var entry_parent: VBoxContainer = $MarginContainer/ScrollContainer/Items
@onready var sold_out: RichTextLabel = $MarginContainer/SoldOut


func has_entries() -> bool: return !entry_parent.get_children().is_empty()


func add_shop_entry(data:ShopEntryData):
	var shop_entry:ShopEntry = SHOP_ENTRY.instantiate()
	entry_parent.add_child(shop_entry)
	shop_entry.initialize(data)
	
	shop_entry.selected.connect(_on_entry_selected)
	shop_entry.hovered.connect(_on_entry_hovered)


func get_shop_entry_by_data(data:ShopEntryData) -> ShopEntry:
	for child in entry_parent.get_children():
		if child.entry_data == data:
			return child as ShopEntry
	return null


func remove_entry_by_data(data:ShopEntryData) -> void:
	for child in entry_parent.get_children():
		if child.entry_data == data:
			child.queue_free()
			break
	
	sold_out.visible = entry_parent.get_child_count() == 0


func _on_entry_selected(data:ShopEntryData):
	entry_selected.emit(data)
	pass


func _on_entry_hovered(data:ShopEntryData):
	entry_hovered.emit(data)
	pass
