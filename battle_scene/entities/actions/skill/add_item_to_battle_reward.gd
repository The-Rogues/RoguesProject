extends Action
class_name AddItemToRewardAction

enum LootSource { CHEST, POT }

@export var loot_source: LootSource = LootSource.CHEST

# Chest rewards
@export var energy_potion: ItemRewardData
@export var health_potion: ItemRewardData
@export var ai_pack: CardPackRewardData

# Pot rewards
@export var high_chance_item: Array[BattleRewardData]
@export var medium_chance_item: Array[BattleRewardData]
@export var low_chance_item: Array[BattleRewardData]
@export var personality_card_packs: Array[CardPackRewardData]


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
	
	var reward_pool: Array[BattleRewardData]
	if GlobalSessionManager.run_progress.total_energy_potions_used < 2:
		reward_pool.append(energy_potion)
	if GlobalSessionManager.run_progress.total_health_potions_used < 2:
		reward_pool.append(health_potion)
	if GlobalSessionManager.run_progress.total_ai_packs_found < 2 && GlobalSessionManager.run_progress.ai_mode:
		reward_pool.append(ai_pack)
	
	if reward_pool.size() < 0:
		return null
	
	var ret_reward: BattleRewardData = reward_pool.pick_random()
	
	if ret_reward == energy_potion:
		GlobalSessionManager.run_progress.total_energy_potions_used += 1
	if ret_reward == health_potion:
		GlobalSessionManager.run_progress.total_health_potions_used += 1
	if ret_reward == ai_pack:
		GlobalSessionManager.run_progress.total_ai_packs_found += 1
	
	return ret_reward



func get_pot_item() -> BattleRewardData:
	var roll := randf()
	# 60%
	if roll < 0.6:
		if high_chance_item.is_empty():
			return null
		return high_chance_item.pick_random()
	# 30%
	elif roll < 0.95:
		if randf() < 0.5:
			return personality_card_packs.pick_random()
		else: 
			if medium_chance_item.is_empty():
				return null
			return medium_chance_item.pick_random()
	# 10%
	else:
		if low_chance_item.is_empty():
			return null
		return low_chance_item.pick_random()
