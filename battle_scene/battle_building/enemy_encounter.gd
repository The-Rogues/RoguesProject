extends Resource
class_name EnemyEncounter

@export var encounter_name:String = "enemy encounter name"
@export var gold:GoldRewardData
@export var item_pool:Array[ItemRewardData]
@export var enemies:Array[MonsterData]

const ITEM_CHANCE = 0.4

func get_battle_rewards() -> Array[BattleRewardData]:
	var rewards:Array[BattleRewardData] = [gold]
	
	if randi() <= ITEM_CHANCE and not item_pool.is_empty():
		rewards.append(item_pool.pick_random())
	
	return rewards
