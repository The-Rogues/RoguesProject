extends Resource
class_name FloorSpawnPool
## Resource for the spawn pool of enemies and objects in a given floor based
## on the rarity of each group.
## 
## Uses in loading battle scenes by choosing a random enemy encounter and object
## layout based on their rarity, where rarity is an enum.
## This allows for enemy encounters and object layouts to be crafted by hand
## while also allowing for variation in battle scenes. This model assumes
## that enemies will be designed to challenge the player uniquely when 
## grouped with other supportive enemies, and encounters are winnable given
## any loadout of the player.
## Intended to be used as a creatable asset in the file system where a unique
## floor spawn pool is made by hand for each floor in a roguelike


enum Rarity {COMMON, UNCOMMON, RARE, SUPER_RARE}
## References to possible enemy encounters in the given floor
@export var enemy_encounters:Array[EnemyEncounter]
## References to possible object layouts in the given floor
@export var object_layouts:Array[BattleObjectLayout]

## Returns a dictionary where a passed array of objects with a rarity member
## value are sorted into key value groups based on their rarity.
## Ex. Enemy1.rarity = Rarity.COMMON, so they are addes to the dictionary as:
## {RARITY.COMMON: [Enemy1,], RARITY.UNCOMMON:[], RARITY.RARE:[], RARITY.SUPER_RARE:[]}
func _get_rarity_ranked_dictionary(pool) -> Dictionary:
	var ranked_dictionary = {
		Rarity.COMMON:[],
		Rarity.UNCOMMON:[],
		Rarity.RARE:[],
		Rarity.SUPER_RARE:[],
	}
	
	for entity in pool:
		match entity.rarity:
			Rarity.COMMON:
				ranked_dictionary[Rarity.COMMON].append(entity)
			Rarity.UNCOMMON:
				ranked_dictionary[Rarity.UNCOMMON].append(entity)
			Rarity.RARE:
				ranked_dictionary[Rarity.RARE].append(entity)
			Rarity.SUPER_RARE:
				ranked_dictionary[Rarity.SUPER_RARE].append(entity)
	
	return ranked_dictionary


func pick_ranked_item_recusive(dictionary:Dictionary, rarity:Rarity):
	if rarity == Rarity.SUPER_RARE and dictionary[rarity].is_empty():
		return pick_ranked_item_recusive(dictionary, Rarity.SUPER_RARE)
	
	if rarity == Rarity.RARE and dictionary[rarity].is_empty():
		return pick_ranked_item_recusive(dictionary, Rarity.UNCOMMON)
	
	if rarity == Rarity.UNCOMMON and dictionary[rarity].is_empty():
		return pick_ranked_item_recusive(dictionary, Rarity.COMMON)
	
	if rarity == Rarity.COMMON and dictionary[rarity].is_empty():
		return null
	
	
	return dictionary[rarity].pick_random()

# TODO: Experiment with rarity draw to use a weighted system over finite values
## Returns a random enemy encounter. Currently has finite rarity values:
## COMMON is 50%, UNCOMMON is 25%, RARE is 10%, and SUPER_RARE is 5%
func get_enemy_encounter():
	var ranked_encounters = _get_rarity_ranked_dictionary(enemy_encounters)
	var draw = randf()
	
	if draw <= 0.5:
		return pick_ranked_item_recusive(ranked_encounters, Rarity.COMMON)
	elif draw <= 85:
		return pick_ranked_item_recusive(ranked_encounters, Rarity.UNCOMMON)
	elif draw <= 95:
		return pick_ranked_item_recusive(ranked_encounters, Rarity.RARE)
	else:
		return pick_ranked_item_recusive(ranked_encounters, Rarity.SUPER_RARE)

## Returns a random object layout. Currently has finite rarity values:
## COMMON is 50%, UNCOMMON is 25%, RARE is 10%, and SUPER_RARE is 5%
func get_object_layout():
	var ranked_layouts = _get_rarity_ranked_dictionary(object_layouts)
	var draw = randf()
	if draw <= 0.5:
		return pick_ranked_item_recusive(ranked_layouts, Rarity.COMMON)
	elif draw <= 85:
		return pick_ranked_item_recusive(ranked_layouts, Rarity.UNCOMMON)
	elif draw <= 95:
		return pick_ranked_item_recusive(ranked_layouts, Rarity.RARE)
	else:
		return pick_ranked_item_recusive(ranked_layouts, Rarity.SUPER_RARE)
