extends Control
class_name ItemSlotUI

signal clicked(index:int)
signal activated(index:int)

@export var item_icon_button: TextureButton
@export var item_texture_rect: TextureRect
@export var price_label:Label
@export var contents:VBoxContainer
@export var context_panel:ContextPanel
@export var activate_label:Label

@export var display_sell_price:bool = false
@export var is_shop_item:bool = false
@export var item_price:int = 0

var index:int

func _ready() -> void:
	item_texture_rect.visible = false
	item_icon_button.disabled = true
	price_label.visible = false
	activate_label.text = "Use"

func initialize(item_data:ItemData, new_index:int):
	var context:String = item_data.name + "\n" + item_data.description
	context_panel.set_context(context)
	item_texture_rect.texture = item_data.display_texture
	item_icon_button.disabled = false
	item_texture_rect.visible = true
	
	if is_shop_item:
		price_label.visible = true
		if display_sell_price:
			price_label.text = str(item_price/2) + "G"
			activate_label.text = "sell"
		else:
			price_label.text = str(item_price) + "G"
			activate_label.text = "Buy"
	index = new_index

func _on_item_slot_clicked() -> void:
	contents.visible = !contents.visible
	if contents.visible:
		clicked.emit(index)
	pass # Replace with function body.

func _on_activate_button_up() -> void:
	activated.emit(index)
	pass # Replace with function body.
