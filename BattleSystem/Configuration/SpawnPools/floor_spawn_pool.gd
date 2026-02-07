extends Resource
class_name FloorSpawnPool

enum Rarity {COMMON, UNCOMMON, RARE}
@export var enemy_pool:Array[EnemyData]
@export var object_layouts:Array[BattleObjectLayout]

const MIN_ENEMY_COUNT = 1
const MAX_ENEMY_COUNT = 3

func get_enemies():
	var enemy_count:int = randi_range(MIN_ENEMY_COUNT, MAX_ENEMY_COUNT)
	var ranked_enemies = get_rarity_ranked_dictionary(enemy_pool)
	var chosen_enemies:Array[EnemyData] = []
	var draw = randf()
	
	for i in range(0, enemy_count):
		draw = randf()
		if draw <= 0.45:
			chosen_enemies.append(pick_from_ranked_pool(ranked_enemies, Rarity.COMMON))
		elif draw <= 0.85:
			chosen_enemies.append(pick_from_ranked_pool(ranked_enemies, Rarity.UNCOMMON))
		else:
			chosen_enemies.append(pick_from_ranked_pool(ranked_enemies, Rarity.RARE))
	return chosen_enemies

func get_object_layout():
	var ranked_layouts = get_rarity_ranked_dictionary(object_layouts)
	var chosen_object_layout:BattleObjectLayout = null
	
	var draw = randf()
	if draw <= 0.45:
		chosen_object_layout = pick_from_ranked_pool(ranked_layouts, Rarity.COMMON)
	elif draw <= 0.85:
		chosen_object_layout = pick_from_ranked_pool(ranked_layouts, Rarity.UNCOMMON)
	else:
		chosen_object_layout = pick_from_ranked_pool(ranked_layouts, Rarity.RARE)
	
	return chosen_object_layout

func get_rarity_ranked_dictionary(pool):
	var ranked_dictionary = {
		Rarity.COMMON:[],
		Rarity.UNCOMMON:[],
		Rarity.RARE:[],
	}
	
	for entity in pool:
		match entity.rarity:
			Rarity.COMMON:
				ranked_dictionary[Rarity.COMMON].append(entity)
			Rarity.UNCOMMON:
				ranked_dictionary[Rarity.UNCOMMON].append(entity)
			Rarity.RARE:
				ranked_dictionary[Rarity.RARE].append(entity)
	
	return ranked_dictionary

func pick_from_ranked_pool(ranked_dictionary:Dictionary, rarity:Rarity):
	if rarity == Rarity.RARE:
		if ranked_dictionary[Rarity.RARE].is_empty():
			return pick_from_ranked_pool(ranked_dictionary, Rarity.UNCOMMON)
	elif rarity == Rarity.UNCOMMON:
		if ranked_dictionary[ItemData.Rarity.RARE].is_empty():
			return pick_from_ranked_pool(ranked_dictionary, Rarity.COMMON)
	elif ranked_dictionary[ItemData.Rarity.COMMON].is_empty():
		return null
	
	return ranked_dictionary[rarity].pick_random()
