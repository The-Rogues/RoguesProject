extends AddItemResult
class_name RandomRareResult

@export var health_potion: ItemData
@export var item_pouch: ItemData

func resolve():
	var reward_pool: Array[ItemData]
	if GlobalSessionManager.run_progress.total_health_potions_used < 2:
		reward_pool.append(health_potion)
	if GlobalSessionManager.run_progress.total_item_packs_used < 2:
		reward_pool.append(item_pouch)
	
	if reward_pool.size() < 0:
		return null
	
	var ret_reward: ItemData = reward_pool.pick_random()
	
	if ret_reward == health_potion:
		GlobalSessionManager.run_progress.total_health_potions_used += 1
	if ret_reward == item_pouch:
		GlobalSessionManager.run_progress.total_item_packs_used += 1
	
	item = ret_reward
	super()
