extends Resource
class_name EnemyEncounter

@export_range(1, 100) var weight:int = 1
@export var encounter_name:String = "enemy encounter name"
@export var gold:GoldRewardData
@export var card_loot:CardRewardData
@export var item_reward:ItemRewardPool = preload(
	"res://content/scene_configuration/battle_loot/battle_item_loot.tres")
@export var enemies:Array[MonsterData]
@export var battlefield_layouts: Array[BattleFieldConfig] = []
@export var disable_card_reward:bool = false

const cards = preload("res://content/scene_configuration/battle_loot/battle_card_draw.tres")
const ITEM_CHANCE = 0.5

func get_battle_rewards() -> Array[BattleRewardData]:
	var rewards:Array[BattleRewardData] = [gold]
	
	if randf() <= ITEM_CHANCE and not item_reward.item_rewards.is_empty():
		var item_reward = item_reward.get_item_reward()
		rewards.append(item_reward)
	
	if card_loot:
		rewards.append(card_loot)
	elif !disable_card_reward:
		rewards.append(cards)
	
	
	return rewards
