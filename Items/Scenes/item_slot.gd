extends Control
class_name ItemSlot

signal clicked(index:int)
signal used(index:int, item_slot:ItemSlot)
signal discard(index:int, item_slot:ItemSlot)

@export var item_icon_button: TextureButton
@export var item_texture_rect: TextureRect
@export var contents:VBoxContainer
@export var context_panel:ContextPanel
@export var use_button:Button


var index:int


func _ready() -> void:
	item_texture_rect.visible = false
	item_icon_button.disabled = true


func initialize(item_data:ItemData, new_index:int):
	var context:String = item_data.name + "\n" + item_data.description
	context_panel.set_context(context)
	item_texture_rect.texture = item_data.display_texture
	item_icon_button.disabled = false
	item_texture_rect.visible = true
	
	index = new_index
	
	if item_data is KeyItem:
		item_icon_button.disabled = true


func _on_item_slot_clicked() -> void:
	contents.visible = true
	clicked.emit(index)


func _on_use_button_up() -> void:
	used.emit(index, self)
	pass # Replace with function body.


func _on_discard_button_up() -> void:
	used.emit(index, self)
	pass # Replace with function body.
