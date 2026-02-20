extends Control

@export var override_shop_items:Array[ItemData]
@onready var buy_item_interface: ShopItemInterface = $CanvasLayer/Control/ShopMenu/Margin/BuyItems
@onready var sell_item_interface: ShopItemInterface = $CanvasLayer/Control/SellMenu/SellItems

@export var shop_menu:Control
@export var sell_menu:Control
@export var menu:Control
@export var character_sprite:TextureRect
@onready var no_sell_label: Label = $CanvasLayer/Control/SellMenu/Label

var shop_items:Array[ItemData]
var sell_items:Array[ItemData]

func _ready() -> void:
	menu.visible = true
	shop_menu.visible = false
	sell_menu.visible = false
	
	character_sprite.texture = GlobalSessionManager.get_character_texture()
	
	if GlobalSceneLoader.pending_shop_data:
		shop_items = GlobalSceneLoader.get_shop_items()
	else:
		shop_items = override_shop_items
	sell_items = GlobalSessionManager.run_progress.held_items
	if sell_items:
		no_sell_label.visible = false
		sell_item_interface.initialize(sell_items)
	else:
		no_sell_label.visible = true
		sell_item_interface.clear_item_slots()
	
	buy_item_interface.initialize(shop_items)
	buy_item_interface.activate_item.connect(_on_buy_item)
	sell_item_interface.activate_item.connect(_on_sell_item)

func _on_leave_button_up() -> void:
	if !GlobalSessionManager.started_session:
		print("Map scene not loaded")
		return
	GlobalSceneLoader.load_scene("res://Map/map_screen/MapScreen.tscn")
	pass # Replace with function body.

func _on_buy_item(index:int):
	print("attempt buy")
	if not GlobalSessionManager.buy_item(shop_items[index]):
		return
	
	buy_item_interface.confirm_transaction(index)
	
	no_sell_label.visible = false
	sell_items = GlobalSessionManager.run_progress.held_items
	sell_item_interface.initialize(sell_items)

func _on_sell_item(index:int):
	GlobalSessionManager.sell_held_item(sell_items[index])
	sell_item_interface.confirm_transaction(index)
	
	if sell_items.is_empty():
		no_sell_label.visible = true

func _on_open_shop() -> void:
	shop_menu.visible = true
	menu.visible = false
	pass # Replace with function body.

func open_sell_menu() -> void:
	sell_menu.visible = true
	menu.visible = false
	pass # Replace with function body.

func _return_to_menu() -> void:
	sell_menu.visible = false
	shop_menu.visible = false
	menu.visible = true
	pass # Replace with function body.


func _on_barter_button_up() -> void:
	print("Enter text to speak to shop owner")
	pass # Replace with function body.
