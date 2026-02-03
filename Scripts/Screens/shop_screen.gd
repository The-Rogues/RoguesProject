extends Control

@export var override_shop_items:Array[ItemData]
@export var shop_item_interface:ItemInterface
@export var shop_menu:Control
@export var sell_menu:Control
@export var menu:Control
@export var gold_label:Label
var shop_items:Array[ItemData]

func _ready() -> void:
	menu.visible = true
	shop_menu.visible = false
	sell_menu.visible = false
	
	if GlobalSceneLoader.pending_shop_data:
		shop_items = GlobalSceneLoader.pending_shop_data.pick_shop_items()
		gold_label.text = str(GlobalSessionManager.get_gold()) + "G"
	else:
		shop_items = override_shop_items
		gold_label.text = "0G"
	
	shop_item_interface.initialize(shop_items)
	shop_item_interface.activate_item.connect(_on_buy_item)

func _on_leave_button_up() -> void:
	if !GlobalSessionManager.started_session:
		print("Map scene not loaded")
		return
	GlobalSceneLoader.load_scene("res://Map/map_screen/MapScreen.tscn")
	pass # Replace with function body.

func _on_buy_item(index:int):
	print("attempt buy")
	if GlobalSessionManager.can_buy_item(shop_items[index].shop_price):
		GlobalSessionManager.buy_item(shop_items[index])
	gold_label.text = str(GlobalSessionManager.get_gold()) + "G"
	pass

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
