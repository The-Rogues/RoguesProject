### achievement_manager.gd
### global Achievements
extends Node
class_name AchievementsManager

signal achievement_unlocked(achievement:AchievementData)


signal achievements_reset
@export var achievements:Array[AchievementData]


func _ready():
	initialize()


func initialize() -> void:
	# Prevent duplicate connections
	_disconnect_existing()

	# Connect every signal from Events
	Events.run_completed.connect(_on_run_completed)
	Events.used_personality_trait.connect(_on_used_personality_trait)
	Events.personality_changed.connect(_on_personality_changed)
	Events.item_used.connect(_on_item_used)
	Events.energy_used.connect(_on_energy_used)
	Events.chest_opened.connect(_on_chest_opened)
	Events.friend_summoned.connect(_on_friend_summoned)
	Events.object_placed.connect(_on_object_placed)
	Events.battle_won.connect(_on_battle_won)
	Events.gold_collected.connect(_on_gold_collected)
	Events.card_collected.connect(_on_card_collected)

	# Initialize achievement state
	for achievement in achievements:
		if achievement.completed:
			continue


func _disconnect_existing() -> void:
	if Events.run_completed.is_connected(_on_run_completed):
		Events.run_completed.disconnect(_on_run_completed)

	if Events.used_personality_trait.is_connected(_on_used_personality_trait):
		Events.used_personality_trait.disconnect(_on_used_personality_trait)

	if Events.personality_changed.is_connected(_on_personality_changed):
		Events.personality_changed.disconnect(_on_personality_changed)

	if Events.item_used.is_connected(_on_item_used):
		Events.item_used.disconnect(_on_item_used)

	if Events.energy_used.is_connected(_on_energy_used):
		Events.energy_used.disconnect(_on_energy_used)

	if Events.chest_opened.is_connected(_on_chest_opened):
		Events.chest_opened.disconnect(_on_chest_opened)

	if Events.friend_summoned.is_connected(_on_friend_summoned):
		Events.friend_summoned.disconnect(_on_friend_summoned)

	if Events.object_placed.is_connected(_on_object_placed):
		Events.object_placed.disconnect(_on_object_placed)

	if Events.battle_won.is_connected(_on_battle_won):
		Events.battle_won.disconnect(_on_battle_won)


func _evaluate_signal(signal_name:String) -> void:
	await get_tree().process_frame
	for achievement in achievements:
		if achievement.listen_signal == signal_name:
			print(achievement.get_rid())
			if achievement.evaluate():
				achievement_unlocked.emit(achievement)
	
	GlobalSaveManager.save_game_stats(GameStats.stats_data)


func reset_achievements():
	for achievement in achievements:
		achievement.completed = false
	achievements_reset.emit()


func _on_run_completed(_summary):
	_evaluate_signal("run_completed")


func _on_used_personality_trait(_trait:String):
	_evaluate_signal("used_personality_trait")


func _on_personality_changed(_trait:String, _weight:int):
	_evaluate_signal("personality_changed")


func _on_item_used(_item):
	_evaluate_signal("item_used")


func _on_energy_used(_amount:int):
	_evaluate_signal("energy_used")


func _on_chest_opened():
	_evaluate_signal("chest_opened")


func _on_friend_summoned(_friend):
	_evaluate_signal("friend_summoned")


func _on_object_placed(_object):
	_evaluate_signal("object_placed")


func _on_battle_won(_encounter, _player_state):
	_evaluate_signal("battle_won")


func _on_gold_collected(_amount:int):
	_evaluate_signal("gold_collected")

func _on_card_collected(_card: CardData):
	_evaluate_signal("card_collected")
