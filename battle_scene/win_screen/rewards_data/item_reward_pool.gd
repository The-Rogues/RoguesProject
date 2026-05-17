extends Resource
class_name ItemRewardPool

@export var item_rewards:Array[ItemRewardData]


func get_item_reward() -> ItemRewardData:
	var chosen_reward:ItemRewardData = null
	
	var index := _get_weighted_index()
	chosen_reward = item_rewards[index]
	return chosen_reward


func _get_weighted_index() -> int:
	var total := 0.0
	for item in item_rewards:
		total += item.weight
	
	var roll := randf() * total
	var cumulative := 0.0
	
	for i in range(item_rewards.size()):
		cumulative += item_rewards[i].weight
		if roll <= cumulative:
			return i
	
	return item_rewards.size() - 1
