extends Resource
class_name EnemyEncounter

@export_range(1, 100) var weight:int = 1
@export var encounter_name:String = "enemy encounter name"
@export var gold:GoldRewardData
@export var card_loot:CardRewardData
@export var item_pool:Array[ItemRewardData]
@export var enemies:Array[MonsterData]
@export var battlefield_layout:BattleFieldConfig = null
@export var use_default_rewards:bool = true

const cards = preload("res://content/scene_configuration/battle_loot/battle_card_draw.tres")
const ITEM_CHANCE = 0.4

func get_battle_rewards() -> Array[BattleRewardData]:
	var rewards:Array[BattleRewardData] = [gold]
	
	if randi() <= ITEM_CHANCE and not item_pool.is_empty():
		rewards.append(item_pool.pick_random())
	
	if use_default_rewards:
		rewards.append(cards)
	
	#if card_loot:
		#rewards.append(card_loot)
	
	
	return rewards
