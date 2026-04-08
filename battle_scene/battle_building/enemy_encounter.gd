extends Resource
class_name EnemyEncounter

@export var encounter_name:String = "enemy encounter name"
@export_range(1, 99999) var gold_reward_amount:int = 25
@export var enemies:Array[MonsterData]

const BONUS_GOLD = 7

func get_gold_reward() -> GoldReward:
	var gold:int = gold_reward_amount + randi_range(0, BONUS_GOLD)
	var reward = GoldReward.new()
	reward.name = "Found Gold (" + str(gold) + ")"
	reward.amount = gold
	reward.display_texture = load("res://Testing/gold_icon.tres")
	return reward
