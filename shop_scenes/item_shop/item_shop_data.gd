extends Resource
class_name ItemShopData
## Data container used to initialize item shops.
## Shops can have services, 1-rare item, 1-card pack, and 4 other items


@export var shop_services:Array[ShopServiceData]
@export var rare_item_pool:Array[ItemData]
@export var item_pool:Array[ItemData]
@export var card_packs:Array[CardPackItemData]

const OTHER_ITEM_COUNT = 4


func get_shop_items() -> Array[ItemData]:
	var shop_items:Array[ItemData] = []
	shop_items.append(rare_item_pool.pick_random())
	
	shop_items.append(card_packs.pick_random())
	
	var unique_items = item_pool.duplicate(true)
	unique_items.shuffle()
	
	var item_amount:int = 0
	
	while !unique_items.is_empty() and item_amount < OTHER_ITEM_COUNT:
		shop_items.append(unique_items.pop_front())
		item_amount += 1
	
	return shop_items
