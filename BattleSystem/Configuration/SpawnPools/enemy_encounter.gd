extends Resource
class_name EnemyEncounter

enum Rarity {COMMON, UNCOMMON, RARE, SUPER_RARE}
@export_range(1, 99999) var base_gold_amount:int = 100
@export_range(1, 99999) var bonus_gold_amount:int = 100
@export var encounter_id:String = "encounter_unkown"
@export var enemies:Array[BattleEntityData]
@export var rarity:Rarity

func get_gold_reward() -> int:
	var final_amount:int = base_gold_amount
	final_amount += randi_range(0, bonus_gold_amount)
	return final_amount
