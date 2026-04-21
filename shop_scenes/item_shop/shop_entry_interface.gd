extends Control

signal selected_entry(entry:ShopEntry)

@onready var entry_container:VBoxContainer = $ScrollContainer/EntryContainer
var Shop_Entry = preload("res://shop_scenes/shop_entry.tscn")


func update_shop_ui(shop_entries:Array[ShopEntryData]) -> void:
	for child in entry_container.get_children():
		child.queue_free()
	await get_tree().process_frame
	
	for data in shop_entries:
		var entry:ShopEntry = Shop_Entry.instantiate()
		entry_container.add_child(entry)
		entry.initialize(data)
		entry.selected.connect(_on_entry_selected)


func _on_entry_selected(shop_entry:ShopEntry) -> void:
	selected_entry.emit(shop_entry)


func find_and_remove_entry(shop_entry:ShopEntry) -> bool:
	for entry in entry_container.get_children():
		if entry == shop_entry:
			entry.queue_free()
			return true
	return false
