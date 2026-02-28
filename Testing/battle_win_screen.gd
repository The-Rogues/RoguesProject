extends Control
class_name BattleWinScreen

@onready var loot: LootPanel = $Loot
@onready var continue_label: SelectButton = $ContinueMargin/Continue

const SHARED_CARDS = preload("res://Battle/Loot/shared_card_reward_pool.tres")

func initialize(encounter:EnemyEncounter, battle_instance:BattleManager):
	loot.initialize(
		encounter.get_gold_reward(),
		SHARED_CARDS,
		battle_instance.character_personality
	)
	
	GlobalSessionManager.save_character_health(
		battle_instance.player_entity._health.current_health
	)
	
	_clear_battle_lock()
	loot.all_rewards_collected.connect(_on_all_rewards_collected)
	loot.selected_card.connect(_on_card_selected)
	continue_label.text = "Skip Rewards"


func _on_all_rewards_collected():
	continue_label.text = "Continue"


func _on_card_selected(card_data:CardData):
	GlobalSessionManager.run_progress.card_deck.add_card(card_data)
	pass


func _on_continue_clicked() -> void:
	if GlobalSessionManager.run_progress == null:
		GlobalSceneLoader.load_scene(GlobalSceneLoader.MAIN_MENU_PATH)
		return
	
	GlobalSaveManager.save_run(GlobalSessionManager.run_progress)
	GlobalSceneLoader.load_scene(GlobalSceneLoader.MAP_SCENE_PATH)
	pass # Replace with function body.


func _clear_battle_lock() -> void:
	if GlobalSessionManager.run_progress == null:
		return
	if GlobalSessionManager.run_progress.battle == null:
		return
	GlobalSessionManager.run_progress.battle.is_active = false
	GlobalSaveManager.save_run(GlobalSessionManager.run_progress)
