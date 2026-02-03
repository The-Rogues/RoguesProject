extends Resource
class_name FloorEnemyPool

# Stores a hierarchical list of enemy pools
# Ideally, higher key values = more difficult enemy pools to choose from
# Ex. key values < 4 are low tier enemy encounters at the beginning of the floor
#     4 < key values < 8 are mid tier enemy encounters
#	  8 < key values are high tier enemy encounters for the late stage of a floor 
@export var tiers:Dictionary[int, EnemyPool]
# Higher difficulty level should correspond to player progress

# Picks a random enemy group from a tiered pool
func get_enemy_group(difficulty_level:int):
	var highest_key:int = 0
	for tier_key in tiers:
		highest_key = max(tier_key, highest_key)
		if difficulty_level <= tier_key:
			var pool = tiers.get(tier_key)
			return pool.enemy_groups.pick_random()
	
	return tiers[highest_key].enemy_groups.pick_random()
