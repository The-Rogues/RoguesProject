extends Resource
class_name CardPool

enum Rarity {COMMON, UNCOMMON, RARE, SUPER_RARE}

@export var common:Array[CardData]
@export var uncommonn:Array[CardData]
@export var rare:Array[CardData]
@export var super_rare:Array[CardData]

const COMMON_RARITY = 0.40
const UNCOMMON_RARITY = 0.65
const RARE_RARITY = 0.90

func get_items(item_count:int) -> Array[CardData]:
	var dictionary = _get_rarity_dictionary()
	var items:Array[CardData]
	for i in range(0, item_count):
		var draw = randi()
		if draw <= COMMON_RARITY:
			items.append(_pick_ranked_item_recusive(dictionary, Rarity.COMMON))
		elif draw <= UNCOMMON_RARITY:
			items.append(_pick_ranked_item_recusive(dictionary, Rarity.COMMON))
		if draw <= RARE_RARITY:
			items.append(_pick_ranked_item_recusive(dictionary, Rarity.COMMON))
		else:
			items.append(_pick_ranked_item_recusive(dictionary, Rarity.COMMON))
	return items


func _get_rarity_dictionary():
	var ranked_dictionary = {
		Rarity.COMMON:[],
		Rarity.UNCOMMON:[],
		Rarity.RARE:[],
		Rarity.SUPER_RARE:[],
	}
	
	for item in common:
		ranked_dictionary[Rarity.COMMON].append(item)
	for item in uncommonn:
		ranked_dictionary[Rarity.UNCOMMON].append(item)
	for item in rare:
		ranked_dictionary[Rarity.RARE].append(item)
	for item in super_rare:
		ranked_dictionary[Rarity.SUPER_RARE].append(item)
	
	return ranked_dictionary


func _pick_ranked_item_recusive(dictionary:Dictionary, rarity:Rarity):
	if rarity == Rarity.SUPER_RARE and dictionary[rarity].is_empty():
		return _pick_ranked_item_recusive(dictionary, Rarity.SUPER_RARE)
	
	if rarity == Rarity.RARE and dictionary[rarity].is_empty():
		return _pick_ranked_item_recusive(dictionary, Rarity.UNCOMMON)
	
	if rarity == Rarity.UNCOMMON and dictionary[rarity].is_empty():
		return _pick_ranked_item_recusive(dictionary, Rarity.COMMON)
	
	if rarity == Rarity.COMMON and dictionary[rarity].is_empty():
		return null
	
	return dictionary[rarity].pick_random()
