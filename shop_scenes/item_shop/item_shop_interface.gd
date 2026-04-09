extends PanelContainer

@onready var shop_entry_interface: ShopEntryInterface = $VBoxContainer/Interface/ShopEntryInterface
@onready var your_items: ShopEntryInterface = $VBoxContainer/Interface/YourItems

@onready var description: RichTextLabel = $VBoxContainer/Interface/VBoxContainer/Context/MarginContainer/Description
@onready var buy_button: Button = $VBoxContainer/Interface/VBoxContainer/Button/Buy
@onready var sell_button: Button = $VBoxContainer/Options/Option1/Sell

@export var shop_items:ItemShopData

@onready var buy_particles: CPUParticles2D = $BuyParticles
@export var test_mode:bool = false

var selected_item:ShopEntryData = null
var sell_mode:bool = false
var pending_service_charge:int = 0

func _ready() -> void:
	shop_entry_interface.entry_selected.connect(_on_entry_selected)
	your_items.entry_selected.connect(_on_entry_selected)
	for entry in shop_items.shop_services:
		shop_entry_interface.add_shop_entry(entry)
	
	var shop_items:Array[ItemData] = shop_items.get_shop_items()
	
	for item in shop_items:
		var item_entry:ShopEntryData = create_item_entry(item)
		shop_entry_interface.add_shop_entry(item_entry)
	
	await get_tree().process_frame
	
	var run = GlobalSessionManager.run_progress
	
	if run:
		for item in run.player_data.items:
			var item_entry:ShopEntryData = create_item_entry(item)
			your_items.add_shop_entry(item_entry)
	
	
	sell_button.disabled = !your_items.has_entries()


func _on_remove_card_service(card:CardData):
	GlobalSessionManager.run_progress.card_deck.remove_card(card)
	GlobalSessionManager.decrease_gold(pending_service_charge)
	pending_service_charge = 0
	pass


func create_item_entry(data:ItemData) -> ShopEntryData:
	var item_entry:ShopItemData = ShopItemData.new()
	item_entry.item = data
	item_entry.description = data.description
	item_entry.name = data.name
	item_entry.price = data.shop_price
	item_entry.texture = data.display_texture
	item_entry.special = data.rarity == ItemData.Rarity.RARE
	item_entry.exhaustable = true
	return item_entry


func _on_entry_selected(data:ShopEntryData):
	description.text = data.name + "\n" + data.description
	buy_button.visible = true
	
	selected_item = data
	update_buy_button()


func update_buy_button():
	if test_mode:
		return
	
	var run = GlobalSessionManager.run_progress
	
	if sell_mode:
		buy_button.disabled = false
	elif run and selected_item:
		buy_button.disabled = !run.player_data.can_buy_shop_item(
				selected_item.price)
	elif selected_item == null:
		buy_button.disabled = true


func buy_item():
	var entry:ShopEntry = null
	if sell_mode:
		
		entry = your_items.get_shop_entry_by_data(selected_item)
	else:
		entry = shop_entry_interface.get_shop_entry_by_data(selected_item)
		
		if entry.entry_data is ShopItemData:
			var item_entry:ShopItemData = create_item_entry(entry.entry_data.item)
			your_items.add_shop_entry(item_entry)
	
	buy_effect(entry)
	
	if selected_item.exhaustable:
		if sell_mode:
			your_items.remove_entry_by_data(selected_item)
		else:
			shop_entry_interface.remove_entry_by_data(selected_item)
		selected_item = null
	
	sell_button.disabled = !your_items.has_entries()
	description.text = "Sold!"
	update_buy_button()


func buy_effect(entry:ShopEntry):
	if !entry:
		return
	
	var pos = entry.texture_rect.global_position
	pos = Vector2(pos.x + 12, pos.y + 12)
	
	buy_particles.global_position = pos
	buy_particles.emitting = true


#func _on_card_selected(card:CardData, deck:CardDeck):
#	deck.remove_card(card)


func _on_buy_button_up() -> void:
	if test_mode:
		buy_item()
		return
	
	var run = GlobalSessionManager.run_progress
	
	if run == null:
		update_buy_button()
		return
	
	if sell_mode:
		if selected_item is ShopItemData:
			run.player_data.remove_item(selected_item.item)
			run.player_data.set_gold(
					run.player_data.gold + selected_item.item.sell_price)
			buy_item()
	elif run.player_data.can_buy_shop_item(selected_item.price):
		if selected_item is ShopItemData:
			run.player_data.add_item(selected_item.item)
			run.player_data.set_gold(
					run.player_data.gold - selected_item.price)
		else:
			if selected_item.service_id == 0:
				#game_dashboard.open_deck_card_selector()
				#game_dashboard.deck_card_selector.selected_card.connect(_on_card_selected)
				pending_service_charge = selected_item.price
		buy_item()
	
	update_buy_button()


func _on_sell_button_up() -> void:
	sell_mode = !sell_mode
	
	if sell_mode:
		shop_entry_interface.visible = false
		your_items.visible = true
		sell_button.text = "Buy Items"
		buy_button.text = "Sell"
		buy_button.visible = false
		
		buy_button.disabled = !your_items.has_entries()
	else:
		shop_entry_interface.visible = true
		your_items.visible = false
		sell_button.text = "Sell Items"
		buy_button.text = "Buy"
		buy_button.visible = false


func _on_leave_button_up() -> void:
	if !GlobalSessionManager.started_session:
		print("Map scene not loaded")
		return
	GlobalSceneLoader.load_scene("res://Map/map_screen/MapScreen.tscn")
	pass # Replace with function body.
