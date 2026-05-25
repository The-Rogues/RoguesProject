extends Resource
class_name PlayerData
# Data container used to track player stat progression during a run

signal health_updated(current:int, max:int)
signal energy_updated(current:int, max:int)
signal items_updated(items:Array[ItemData])
signal item_capacity_updated(current:int)
signal gold_updated(current:int)
signal cards_updated(cards:Array[CardData])
signal card_removed(card:CardData)

signal item_collected
signal card_collected(card:CardData)
signal gold_collected(amount:int)

@export var name:String = "Player"
@export var character_texture:Texture2D
@export var melee_weapon_texture:Texture2D
@export var ranged_weapon_texture:Texture2D
@export var max_health:int
@export var current_health:int
@export var current_energy:int
@export var max_energy:int
@export var item_capacity:int
@export var items:Array[ItemData]
@export var cards:Array[CardData]
@export var gold:int
@export var personality:PersonalityData

const STARTING_HEALTH = 50
const STARTING_ENERGY = 3
const STARTING_ITEM_CAPACITY = 3
const STARTING_GOLD = 0


func initialize(
	_personality:PersonalityData,
	_cards:Array[CardData]
) -> void:
	max_health = STARTING_HEALTH
	current_health = STARTING_HEALTH
	max_energy = STARTING_ENERGY
	item_capacity = STARTING_ITEM_CAPACITY
	items = []
	cards = _cards.duplicate()
	gold = STARTING_GOLD
	personality = _personality


func set_health(_current:int, _max:int) -> void:
	max_health = _max
	current_health = _current
	health_updated.emit(current_health, max_health)


func set_energy(_current:int, _max:int) -> void:
	current_energy = _current
	max_energy = _max
	energy_updated.emit(_current, _max)


func set_gold(amount:int) -> void:
	if amount > gold:
		gold_collected.emit(amount)
		Events.gold_collected.emit(amount)
	
	gold = amount
	gold_updated.emit(gold)


func set_item_capacity(capacity:int):
	item_capacity = capacity
	item_capacity_updated.emit(item_capacity)


func add_item(item:ItemData) -> bool:
	if items.size() < item_capacity:
		items.append(item)
		items_updated.emit(items)
		item_collected.emit()
		return true
	else:
		return false


func remove_item(item:ItemData) -> bool:
	if items.has(item):
		items.erase(item)
		items_updated.emit(items)
		return true
	else:
		return false


func buy_item(item:ItemData) -> bool:
	if can_pay_price(item.shop_price) and items.size() < item_capacity:
		set_gold(gold - item.shop_price)
		add_item(item)
		return true
	
	return false

func sell_item(item:ItemData) -> bool:
	if items.has(item):
		set_gold(gold + item.sell_price)
		remove_item(item)
		return true
	
	return false


func can_pay_price(price:int):
	return gold >= price


func add_card(card:CardData):
	cards.append(card)
	cards_updated.emit(cards)
	card_collected.emit(card)
	
	Events.card_collected.emit(card)


func add_cards(_cards:Array[CardData]):
	for card in _cards:
		cards.append(card)
	
	cards_updated.emit(cards)
	card_collected.emit()


func remove_card(card:CardData):
	if cards.has(card):
		cards.erase(card)
		card_removed.emit(card)
		cards_updated.emit(cards)


func get_cards_as_instances() -> Array[CardInstance]:
	var card_instances:Array[CardInstance]
	for card in cards:
		var instance = CardInstance.new(card)
		card_instances.append(instance)
	
	return card_instances


func can_buy_card(price: int):
	return gold >= price


func get_key_item(key_id:String) -> ItemData:
	for item in items:
		if item is KeyItem:
			if item.key_id == key_id:
				return item
	return null


func inventory_full() -> bool:
	return items.size() == item_capacity


func connect_to_player_entity(player:PlayerEntity):
	player.health.health_changed.connect(set_health)
	player.energy.energy_changed.connect(set_energy)


func disconnect_from_player_entity(player: PlayerEntity):
	if player.health.health_changed.is_connected(set_health):
		player.health.health_changed.disconnect(set_health)
	
	if player.energy.energy_changed.is_connected(set_energy):
		player.energy.energy_changed.disconnect(set_energy)
