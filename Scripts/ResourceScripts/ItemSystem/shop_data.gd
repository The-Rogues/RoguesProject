extends Resource
class_name ShopData

@export var shop_item_pool:Array[ItemData]

const MIN_SHOP_ITEM_COUNT = 3
const MAX_SHOP_ITEM_COUNT = 8

func get_ranked_item_dictionary():
	var ranked_item_dictionary = {
		ItemData.Rarity.COMMON:[],
		ItemData.Rarity.UNCOMMON:[],
		ItemData.Rarity.RARE:[],
	}
	
	for item in shop_item_pool:
		match item.rarity:
			ItemData.Rarity.COMMON:
				ranked_item_dictionary[ItemData.Rarity.COMMON].append(item)
			ItemData.Rarity.UNCOMMON:
				ranked_item_dictionary[ItemData.Rarity.UNCOMMON].append(item)
			ItemData.Rarity.RARE:
				ranked_item_dictionary[ItemData.Rarity.RARE].append(item)
	
	return ranked_item_dictionary

func pick_item(ranked_list:Dictionary, rarity:ItemData.Rarity):
	if rarity == ItemData.Rarity.RARE:
		if ranked_list[ItemData.Rarity.RARE].is_empty():
			return pick_item(ranked_list, ItemData.Rarity.UNCOMMON)
	elif rarity == ItemData.Rarity.UNCOMMON:
		if ranked_list[ItemData.Rarity.RARE].is_empty():
			return pick_item(ranked_list, ItemData.Rarity.COMMON)
	elif ranked_list[ItemData.Rarity.COMMON].is_empty():
		return null
	
	return ranked_list[rarity].pick_random()

func pick_shop_items():
	var shop_items:Array[ItemData]
	var ranked_items = get_ranked_item_dictionary()
	var shop_item_count:int = randi_range(MIN_SHOP_ITEM_COUNT, MAX_SHOP_ITEM_COUNT)
	
	for i in range(0, shop_item_count):
		var draw = randf()
		if draw <= 0.5:
			shop_items.append(pick_item(ranked_items, ItemData.Rarity.COMMON))
		elif draw <= 0.85:
			shop_items.append(pick_item(ranked_items, ItemData.Rarity.UNCOMMON))
		else:
			shop_items.append(pick_item(ranked_items, ItemData.Rarity.RARE))
			
	shop_items.sort()
	return shop_items
