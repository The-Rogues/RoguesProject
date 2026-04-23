extends Resource
class_name BattleBuilder

@export var tier_1_encounters:Array[EnemyEncounter]
@export var tier_2_encounters:Array[EnemyEncounter]
@export var tier_3_encounters:Array[EnemyEncounter]

@export var tier_1_battlefield_layouts:Array[BattleFieldConfig]
@export var tier_2_battlefield_layouts:Array[BattleFieldConfig]
@export var tier_3_battlefield_layouts:Array[BattleFieldConfig]

const TIER_1_THRESHOLD = 3
const TIER_2_THRESHOLD = 6

var enemy_encounter_cache:Array[EnemyEncounter] = []


func get_enemy_encounter_pool(progress:int) -> Array[EnemyEncounter]:
	if progress <= TIER_1_THRESHOLD:
		return tier_1_encounters
	if progress <= TIER_2_THRESHOLD:
		return tier_2_encounters
	else:
		return tier_3_encounters


func get_battlefield_layout_pool(progress:int) -> Array[BattleFieldConfig]:
	if progress <= TIER_1_THRESHOLD:
		return tier_2_battlefield_layouts
	if progress <= TIER_2_THRESHOLD:
		return tier_2_battlefield_layouts
	else:
		return tier_3_battlefield_layouts


func choose_enemy_encounter(
		encounters:Array[EnemyEncounter]) -> EnemyEncounter:
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
		
		if enemy_encounter_cache.size() == encounters.size():
			enemy_encounter_cache.clear()
		else:
			for encounter in enemy_encounter_cache:
				encounters.erase(encounter)
		
		var enemy_encounter:EnemyEncounter = choose_enemy_encounter(encounters)
		var battlefield_config:BattleFieldConfig = null
		if enemy_encounter.battlefield_layout:
			battlefield_config = enemy_encounter.battlefield_layout
		else:
			battlefield_config = choose_battlefield_layout(layouts)
		
		enemy_encounter_cache.append(enemy_encounter)
		
		return BattleConfig.new(
				enemy_encounter,
				battlefield_config,
				run.player_data
		)
	
	return null
