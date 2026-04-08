extends Resource
class_name BattleBuilder

@export var tier_1_encounters:Array[EnemyEncounter]
@export var tier_2_encounters:Array[EnemyEncounter]
@export var tier_3_encounters:Array[EnemyEncounter]
@export var battle_field_configs:Array[BattleFieldConfig]

const TIER_1_THRESHOLD = 2
const TIER_2_THRESHOLD = 6


func create_battle_config() -> BattleConfig:
	var run := GlobalSessionManager.run_progress
	
	if run:
		var enemy_encounter:EnemyEncounter = null
		var battlefield_config = battle_field_configs.pick_random()
		
		if run.floor_progress <= TIER_1_THRESHOLD:
			enemy_encounter = tier_1_encounters.pick_random()
		elif run.floor_progress <= TIER_2_THRESHOLD:
			enemy_encounter = tier_2_encounters.pick_random()
		else:
			enemy_encounter = tier_3_encounters.pick_random()
		
		return BattleConfig.new(
				enemy_encounter,
				battlefield_config,
				run.player_data
		)
	
	return null
