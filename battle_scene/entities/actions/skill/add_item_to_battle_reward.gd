extends Action
class_name AddItemToRewardAction

enum LootSource { CHEST, POT }

@export var loot_source: LootSource = LootSource.CHEST

# Chest rewards
@export var chest_items: Array[BattleRewardData]

# Pot rewards
@export var high_chance_item: Array[BattleRewardData]
@export var medium_chance_item: Array[BattleRewardData]
@export var low_chance_item: Array[BattleRewardData]


func execute(_context: BattleContext = null, _user: AbstractEntity = null):
	var reward: BattleRewardData = null
	match loot_source:
		LootSource.CHEST:
			reward = get_chest_item()
		LootSource.POT:
			reward = get_pot_item()
	if reward:
		_context.reward_handler.add_reward(reward)



func get_chest_item() -> BattleRewardData:
	if chest_items.is_empty():
		return null
	return chest_items.pick_random()



func get_pot_item() -> BattleRewardData:
	var roll := randf()
	# 60%
	if roll < 0.6:
		if high_chance_item.is_empty():
			return null
		return high_chance_item.pick_random()
	# 30%
	elif roll < 0.9:
		if medium_chance_item.is_empty():
			return null
		return medium_chance_item.pick_random()
	# 10%
	else:
		if low_chance_item.is_empty():
			return null
		return low_chance_item.pick_random()
