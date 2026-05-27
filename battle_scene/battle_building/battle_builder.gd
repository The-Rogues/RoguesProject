extends Resource
class_name BattleBuilder

@export var tier_1_encounters:Array[EnemyEncounter]
@export var tier_2_encounters:Array[EnemyEncounter]
@export var tier_3_encounters:Array[EnemyEncounter]
@export var tier_4_encounters:Array[EnemyEncounter]
@export var tier_5_encounters:Array[EnemyEncounter]
@export var final_battle_encounter:Array[EnemyEncounter] #final judge arbitor or whatever (array of 1) 

@export var tier_1_battlefield_layouts:Array[BattleFieldConfig]
@export var tier_2_battlefield_layouts:Array[BattleFieldConfig]
@export var tier_3_battlefield_layouts:Array[BattleFieldConfig]
@export var tier_4_battlefield_layouts:Array[BattleFieldConfig]
@export var tier_5_battlefield_layouts:Array[BattleFieldConfig]
@export var final_battle_layout:Array[BattleFieldConfig] #final battle config only array of 1 lol 

const TIER_1_THRESHOLD = 2
const TIER_2_THRESHOLD = 5
const TIER_3_THRESHHOLD = 12
const TIER_4_THRESHHOLD = 16
const FINAL_BATTLE_TEMP = 1

var enemy_encounter_cache:Array[EnemyEncounter] = []
var battle_field_cashe: Array[BattleFieldConfig] = []
var override_encounter:EnemyEncounter = null

func get_enemy_encounter_pool(progress:int) -> Array[EnemyEncounter]:
	#if progress <= FINAL_BATTLE_TEMP:
		#return final_battle_encounter #return array of 1 enemy the boss...
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
	#if progress <= FINAL_BATTLE_TEMP:
		# return final_battle_layout #temp layout ill build it over whatevs 
	if progress <= TIER_1_THRESHOLD:
		return tier_1_battlefield_layouts
	if progress <= TIER_2_THRESHOLD:
		return tier_2_battlefield_layouts
	if progress <= TIER_3_THRESHHOLD:
		return tier_3_battlefield_layouts
	if progress <= TIER_4_THRESHHOLD:
		return tier_4_battlefield_layouts
	
	return tier_5_battlefield_layouts

#need to understand futher.. check later ... 
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
		var progress:int = run.total_rooms_explored #gets num of rooms explored
		var encounters = get_enemy_encounter_pool(progress).duplicate() #calls the function to decide which pool of enemies to choose from based on the progress
		var layouts = get_battlefield_layout_pool(progress).duplicate() # decides which layout based on progress
		if enemy_encounter_cache.size() == encounters.size():
			enemy_encounter_cache.clear()
		else:
			for encounter in enemy_encounter_cache:
				encounters.erase(encounter)
		
		if battle_field_cashe.size() == layouts.size():
			battle_field_cashe.clear()
		else:
			for field in battle_field_cashe:
				layouts.erase(field)
		
		var enemy_encounter:EnemyEncounter = choose_enemy_encounter(encounters)
		var battlefield_config:BattleFieldConfig = null
		if enemy_encounter.battlefield_layout:
			battlefield_config = enemy_encounter.battlefield_layout
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
