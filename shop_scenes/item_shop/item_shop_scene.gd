extends Control
## Initializer for the item shop

signal transaction_completed
signal item_selected
signal failed_to_buy_item

enum ShopState {BUY_ITEMS, SELL_ITEMS}

var shop_state:ShopState = ShopState.BUY_ITEMS

@export var shop_data:ItemShopData

@onready var shop_keeper: Sprite2D = %ShopKeeper
@onready var shop_keeper_dialogue: DialogueText = %ShopKeeperDialogue
@onready var shop_entry_interface: Control = %ShopEntryInterface
@onready var bought_entry_particles: CPUParticles2D = %BoughtEntryParticles
@onready var bought_entry_particles_2: CPUParticles2D = %BoughtEntryParticles2
@onready var you_have_no_items_label: Label = %YouHaveNoItemsLabel

var remaining_entries:Array[ShopEntryData] = []
var pending_service:ShopEntry = null
var player_data:PlayerData = null


# -------------------------------------------------
# Initializing & _ready
# -------------------------------------------------
func _ready() -> void:
	MusicManager.change_song(MusicManager.track_list.shop_theme)
	
	if shop_data:
		initialize(shop_data)


func initialize(data:ItemShopData) -> void:
	var shop_entries:Array[ShopEntryData] = []
	
	# Adding Services
	shop_entries.append_array(data.shop_services)
	
	# Adding Items
	var shop_items:Array[ItemData] = data.get_shop_items()
	for item_data in shop_items:
		var item_entry = _create_shop_item_entry(item_data)
		shop_entries.append(item_entry)
	
	# Initialize tracking bought entries
	remaining_entries = shop_entries
	shop_entry_interface.update_shop_ui(shop_entries)
	shop_entry_interface.selected_entry.connect(_on_entry_selected)
	
	# Referencing player data
	# TODO: Figure out a way to make this scene testable without a global
	if GlobalSessionManager.run_progress:
		player_data = GlobalSessionManager.run_progress.player_data
		GlobalSessionManager.complete_current_room()
	
	
	shop_keeper.texture = data.shop_keeper_textures.pick_random()
	shop_keeper_dialogue.say("Welcome!")


# -------------------------------------------------
# Processing Clicked Shop Entries
# -------------------------------------------------
func _on_entry_selected(shop_entry:ShopEntry):
	item_selected.emit()
	
	if !player_data:
		_process_bought_entry(shop_entry)
		return
	
	if not player_data.can_pay_price(shop_entry.entry_data.price):
		#Reject
		failed_to_buy_item.emit()
		shop_entry.reject()
		shop_keeper_dialogue.say("Not enough Gold!")
		return
	
	if shop_entry.entry_data is ShopServiceData:
		_process_shop_service(shop_entry)
		return
	
	if shop_entry.entry_data is ShopItemData:
		if shop_state == ShopState.BUY_ITEMS:
			if player_data.inventory_full():
				#Reject
				shop_entry.reject()
				shop_keeper_dialogue.say("Your inventory is full!")
			else:
				player_data.buy_item(shop_entry.entry_data.item)
				_process_bought_entry(shop_entry)
		elif shop_state == ShopState.SELL_ITEMS:
			player_data.sell_item(shop_entry.entry_data.item)
			_process_bought_entry(shop_entry)
		return
	
	shop_entry.reject()


func _process_shop_service(shop_entry:ShopEntry):
	if shop_entry.entry_data is ShopServiceData:
		pending_service = shop_entry
		match shop_entry.entry_data.service_id:
			0:
				GlobalSessionInterface.open_card_removal()
				if !GlobalSessionInterface.card_remover.is_connected("closed",
						_on_card_removal_returned):
					GlobalSessionInterface.card_remover.closed.connect(
							_on_card_removal_returned)



func _process_bought_entry(shop_entry:ShopEntry):
	_play_buy_effect(shop_entry)
	
	if shop_entry.entry_data.exhaustable:
		shop_entry_interface.find_and_remove_entry(shop_entry)
	
	shop_keeper_dialogue.say("Thank you.")


# -------------------------------------------------
# Helper Functions
# -------------------------------------------------

# Creates a shop entry to purchase a passed item
func _create_shop_item_entry(
		data:ItemData, 
		use_sell_price:bool = false) -> ShopEntryData:
	var item_entry:ShopItemData = ShopItemData.new()
	item_entry.item = data
	item_entry.description = data.description
	item_entry.name = data.name
	
	if use_sell_price:
		item_entry.price = data.sell_price
	else:
		item_entry.price = data.shop_price
	
	item_entry.texture = data.display_texture
	item_entry.special = data.rarity == ItemData.Rarity.RARE
	item_entry.exhaustable = true
	return item_entry


# Plays a particle effect over a bought entry
func _play_buy_effect(entry:ShopEntry):
	if !entry:
		return
	
	transaction_completed.emit()
	
	var pos = entry.texture_rect.global_position
	pos = Vector2(pos.x + 200, pos.y + 12)
	
	bought_entry_particles_2.global_position = pos
	bought_entry_particles.global_position = pos
	bought_entry_particles.emitting = true
	bought_entry_particles_2.emitting = true

# -------------------------------------------------
# Input Events
# -------------------------------------------------
func _on_buy_items_toggled(toggled_on: bool) -> void:
	if toggled_on:
		shop_entry_interface.update_shop_ui(remaining_entries)
		
		shop_state = ShopState.BUY_ITEMS


func _on_sell_items_toggled(toggled_on: bool) -> void:
	if !player_data:
		return
	
	if toggled_on:
		var sellable_items:Array[ItemData] = player_data.items.duplicate(true)
		
		var sellable_item_entries:Array[ShopEntryData]
		for data in sellable_items:
			var entry = _create_shop_item_entry(data, true)
			sellable_item_entries.append(entry)
		
		you_have_no_items_label.visible = sellable_items.is_empty()
		
		shop_entry_interface.update_shop_ui(sellable_item_entries)
		shop_state = ShopState.SELL_ITEMS


func _on_card_removal_returned(completed:bool):
	if completed and pending_service and player_data:
		player_data.set_gold(
				player_data.gold - pending_service.entry_data.price)
		
		_play_buy_effect(pending_service)
		pending_service = null


func _on_leave_button_up() -> void:
	$"Options/Buy Items".disabled = true
	$"Options/Sell Items".disabled = true
	$Options/Leave.disabled = true
	shop_entry_interface.visible = false
	
	if GlobalSessionManager.run_progress.run_map:
		shop_keeper_dialogue.say("Goodbye.")
		await shop_keeper_dialogue.finished
		await get_tree().create_timer(1).timeout
		GlobalSceneLoader.load_scene(GlobalSceneLoader.MAP_SCENE_PATH)
	else:
		shop_keeper_dialogue.say("Theres nowhere else to go.")
