extends Control
class_name ItemSlotUI

signal clicked(index:int)
signal activated(index:int)

@export var item_icon_button: TextureButton
@export var item_texture_rect: TextureRect
@export var contents:VBoxContainer
@export var context_panel:ContextPanel

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

func _on_item_slot_clicked() -> void:
	contents.visible = !contents.visible
	if contents.visible:
		clicked.emit(index)
	pass # Replace with function body.

func _on_activate_button_up() -> void:
	activated.emit(index)
	pass # Replace with function body.
