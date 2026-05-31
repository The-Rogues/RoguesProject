extends Resource
class_name BattleBuilder

@export var tier_1_encounters:Array[EnemyEncounter]
@export var tier_2_encounters:Array[EnemyEncounter]
@export var tier_3_encounters:Array[EnemyEncounter]
@export var tier_4_encounters:Array[EnemyEncounter]
@export var tier_5_encounters:Array[EnemyEncounter]

@export var tier_1_battlefield_layouts:Array[BattleFieldConfig]
@export var tier_2_battlefield_layouts:Array[BattleFieldConfig]
@export var tier_3_battlefield_layouts:Array[BattleFieldConfig]
@export var tier_4_battlefield_layouts:Array[BattleFieldConfig]
@export var tier_5_battlefield_layouts:Array[BattleFieldConfig]

const TIER_1_THRESHOLD = 2
const TIER_2_THRESHOLD = 5
const TIER_3_THRESHHOLD = 8
const TIER_4_THRESHHOLD = 16

var enemy_encounter_cache:Array[EnemyEncounter] = []
var battle_field_cashe: Array[BattleFieldConfig] = []
var override_encounter:EnemyEncounter = null

func get_enemy_encounter_pool(progress:int) -> Array[EnemyEncounter]:
	if progress <= TIER_1_THRESHOLD:
		return tier_1_encounters
	if progress <= TIER_2_THRESHOLD:
		return tier_2_encounters
	if progress <= TIER_3_THRESHHOLD:
		return tier_3_encounters
	if progress <= TIER_4_THRESHHOLD:
		return tier_4_encounters
	
	return tier_5_encounters


func get_battlefield_layout_pool(progress:int) -> Array[BattleFieldConfig]:
	if progress <= TIER_1_THRESHOLD:
		return tier_1_battlefield_layouts
	if progress <= TIER_2_THRESHOLD:
		return tier_2_battlefield_layouts
	if progress <= TIER_3_THRESHHOLD:
		return tier_3_battlefield_layouts
	if progress <= TIER_4_THRESHHOLD:
		return tier_4_battlefield_layouts
	
	return tier_5_battlefield_layouts


func choose_enemy_encounter(
		encounters:Array[EnemyEncounter]) -> EnemyEncounter:
	if override_encounter:
		var encounter = override_encounter.duplicate(true)
		override_encounter = null
		return encounter
	
	var weight = 0
	
	for encounter in encounters:
		weight += encounter.weight
	
	var random_number = randi_range(0, weight)
	
	for encounter in encounters:
		random_number -= encounter.weight
		
		if random_number <= 0:
			return encounter
	
	return encounters[0]


func choose_battlefield_layout(
		layouts:Array[BattleFieldConfig]) -> BattleFieldConfig:
	var weight = 0
	
	for layout in layouts:
		weight += layout.weight
	
	var random_number = randi_range(0, weight)
	
	for layout in layouts:
		random_number -= layout.weight
		
		if random_number <= 0:
			return layout
	
	return layouts[0]


func create_battle_config() -> BattleConfig:
	var run := GlobalSessionManager.run_progress
	if run:
		var progress:int = run.total_rooms_explored
		var encounters = get_enemy_encounter_pool(progress).duplicate()
		var layouts = get_battlefield_layout_pool(progress).duplicate()
		
		for encounter in enemy_encounter_cache:
			encounters.erase(encounter)
		
		for field in battle_field_cashe:
			layouts.erase(field)
		
		var enemy_encounter:EnemyEncounter = choose_enemy_encounter(encounters)
		var battlefield_config:BattleFieldConfig = null
		if enemy_encounter.battlefield_layouts.size() > 0:
			battlefield_config = enemy_encounter.battlefield_layouts.pick_random()
		else:
			battlefield_config = choose_battlefield_layout(layouts)
			battle_field_cashe.append(battlefield_config)
		
		enemy_encounter_cache.append(enemy_encounter)
		
		return BattleConfig.new(
				enemy_encounter,
				battlefield_config,
				run.player_data
		)
	
	return null
