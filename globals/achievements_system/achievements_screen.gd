extends Control

const Achievement = preload("res://globals/achievements_system/achievement.tscn")
@onready var achievements_container: VBoxContainer = %AchievementsContainer
@onready var completion_label: RichTextLabel = %CompletionLabel


func _ready() -> void:
	initialize()


func initialize():
	populate_achievements(Achievements.achievements)


func populate_achievements(data:Array[AchievementData]):
	var completed:int = 0
	
	for achievement_data in data:
		var achievement = Achievement.instantiate()
		achievements_container.add_child(achievement)
		achievement.initialize(achievement_data)
		
		if achievement_data.completed: 
			completed += 1
	
	var percent:float = 0.0
	
	if data.size() > 0:
		percent = (float(completed) / float(data.size())) * 100.0
	
	var progress = str(int(round(percent))) + "%"
	
	completion_label.text = "[wave amp=20.0 freq=20.0 connected=1]Completion %s[/wave]" % progress
