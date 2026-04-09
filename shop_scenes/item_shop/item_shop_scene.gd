extends Control

const ITEM_SHOP_DATA = preload("res://Map/Shop/ItemPools/item_shop_data.tres")
#@export var override_shop_items:Array[ItemData]
@export var shop_keeper_varients:Array[Texture2D]

@onready var shop_items_interface: ShopItemInterface = $CanvasLayer/Control/ShopInterface/VBoxContainer/PanelContainer/HBoxContainer/ShopItems
@onready var sellable_items_interface: ShopItemInterface = $CanvasLayer/Control/ShopInterface/VBoxContainer/PanelContainer/HBoxContainer/SellableItems

@onready var menu_options: HBoxContainer = $CanvasLayer/Control/ShopInterface/VBoxContainer/MenuOptions
@onready var shop_options: HBoxContainer = $CanvasLayer/Control/ShopInterface/VBoxContainer/ShopOptions
@onready var sell_options: HBoxContainer = $CanvasLayer/Control/ShopInterface/VBoxContainer/SellOptions
@onready var item_info: ContextPanel = $CanvasLayer/Control/ShopInterface/VBoxContainer/PanelContainer/HBoxContainer/ItemInfo
@onready var shop_keeper_animator: AnimationPlayer = $ShopKeeper/EntityAnimator
@onready var shop_keeper_sprite: Sprite2D = $ShopKeeper/SpriteRoot/Sprite2D
@onready var buy: Button = $CanvasLayer/Control/ShopInterface/VBoxContainer/ShopOptions/Buy
@onready var sell: Button = $CanvasLayer/Control/ShopInterface/VBoxContainer/SellOptions/Sell


var shop_items:Array[ItemData]
var sellable_items:Array[ItemData]
var selected_item:ItemData
var selected_item_index:int = -1


func _ready() -> void:
	menu_options.visible = true
	shop_options.visible = false
	sell_options.visible = false
	item_info.visible = false
	
	shop_items = ITEM_SHOP_DATA.get_shop_items()
	
	if GlobalSessionManager.run_progress:
		sellable_items = GlobalSessionManager.run_progress.held_items
	else:
		sellable_items = []
	
	if sellable_items:
		sellable_items_interface.initialize(sellable_items)
	else:
		sellable_items_interface.initialize([])
	
	shop_items_interface.initialize(shop_items)
	shop_items_interface.selected_item.connect(_on_selected_item)
	sellable_items_interface.selected_item.connect(_on_selected_item)
	shop_keeper_animator.speed_scale = 0.5
	shop_keeper_animator.play("entity/idle")
	shop_keeper_sprite.texture = shop_keeper_varients.pick_random()


func _on_selected_item(index:int, transaction_type:int, transaction_completed:bool):
	if transaction_type == 0:
		selected_item = shop_items[index]
	else:
		selected_item = sellable_items[index]
	if transaction_completed == true:
		item_info.set_context("item sold")
	
	var context:String = "Item name: " + selected_item.name + "\n" + selected_item.description
	selected_item_index = index
	item_info.set_context(context)
	buy.disabled = false
	sell.disabled = false


func _on_buy_item():
	if selected_item == null:
		return
	
	if not GlobalSessionManager.buy_item(selected_item):
		return
	
	shop_items_interface.confirm_transaction(selected_item_index)
	
	sellable_items = GlobalSessionManager.run_progress.held_items
	sellable_items_interface.initialize(sellable_items)
	
	selected_item = null
	selected_item_index = -1
	
	item_info.set_context("SOLD!")
	buy.disabled = true


func _on_sell_item():
	if selected_item == null:
		return
	
	GlobalSessionManager.sell_held_item(selected_item)
	sellable_items_interface.confirm_transaction(selected_item_index)
	sell.disabled = true


func _on_leave_button_up() -> void:
	if !GlobalSessionManager.started_session:
		print("Map scene not loaded")
		return
	GlobalSceneLoader.load_scene("res://Map/map_screen/MapScreen.tscn")
	pass # Replace with function body.


func _on_barter_button_up() -> void:
	print("Enter text to speak to shop owner")
	pass # Replace with function body.


func _on_shop_button_up() -> void:
	menu_options.visible = false
	shop_options.visible = true
	shop_items_interface.visible = true
	item_info.visible = true
	item_info.set_context("Select any item")
	buy.disabled = true
	
	pass # Replace with function body.


func _on_open_sell_button_up() -> void:
	menu_options.visible = false
	item_info.visible = true
	sellable_items_interface.visible = true
	sell_options.visible = true
	sell.disabled = true
	if sellable_items.is_empty():
		item_info.set_context("You have no items to sell")
	pass # Replace with function body.


func _on_back_from_shop_button_up() -> void:
	menu_options.visible = true
	shop_options.visible = false
	item_info.visible = false
	shop_items_interface.visible = false
	sellable_items_interface.visible = false
	pass # Replace with function body.


func _back_to_menu_button_up() -> void:
	menu_options.visible = true
	shop_options.visible = false
	sellable_items_interface.visible = false
	item_info.visible = false
	shop_items_interface.visible = false
	sell_options.visible = false
	selected_item = null
	selected_item_index = -1
	pass # Replace with function body.
