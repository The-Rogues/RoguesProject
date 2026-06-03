extends Resource
class_name AchievementData

enum StatType {GameStat, BattleStat}

@export var name:String
@export var display_image:Texture2D
@export_multiline var description:String 
@export var completed:bool = false
@export var signal_from:StatType = StatType.GameStat
@export var listen_signal:String
@export var stat_checks:Array[StatRequirement]
@export var save_path: String
const SAVE_DIR := "user://content/achievements/"

func evaluate() -> bool:
	if completed:
		return false
	
	var passed := true
	
	for requirement in stat_checks:
		var value
		if signal_from == StatType.GameStat:
			value = GameStats.stats_data.get(requirement.stat_name)
			
		elif signal_from == StatType.BattleStat:
			value = GameStats.battle_state.get(requirement.stat_name)
	
		match requirement.comparison:
	
			">=":
				if value < requirement.target:
					passed = false
	
			">":
				if value <= requirement.target:
					passed = false
	
			"<=":
				if value > requirement.target:
					passed = false
	
			"<":
				if value >= requirement.target:
					passed = false
	
			"==":
				if value != requirement.target:
					passed = false
	
			"contains":
				if not value.has(requirement.contains_value):
					passed = false
	
			"size>=":
				if value.size() < requirement.target:
					passed = false
	
			"true":
				if value != true:
					passed = false
	
			"false":
				if value != false:
					passed = false
	
	if passed:
		completed = true
		ResourceSaver.save(self, save_path)
		return true
	return false
