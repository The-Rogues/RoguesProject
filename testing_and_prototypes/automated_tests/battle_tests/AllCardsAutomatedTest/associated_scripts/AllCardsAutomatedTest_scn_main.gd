extends Node

@onready var encounter_res: EnemyEncounter = preload("res://testing_and_prototypes/automated_tests/battle_tests/AllCardsAutomatedTest/associated_resources/all_cards_encounter.tres")
@onready var player_res: PlayerData = preload("res://testing_and_prototypes/automated_tests/battle_tests/AllCardsAutomatedTest/associated_resources/all_cards_player.tres")
@onready var progress_res: RunProgress = preload("res://testing_and_prototypes/automated_tests/battle_tests/AllCardsAutomatedTest/associated_resources/all_cards_progress.tres")
@onready var field_res: BattleFieldConfig = preload("res://testing_and_prototypes/automated_tests/battle_tests/AllCardsAutomatedTest/associated_resources/all_cards_battle_field.tres")

var test_enabled: bool = false

func _ready():
	
	if !test_enabled:
		return
	
	GlobalSessionManager.run_progress = progress_res
	GlobalSceneLoader.load_battle_scene()
	GlobalSceneLoader.battle_config = BattleConfig.new(
		encounter_res,
		field_res,
		player_res
	)
	await get_tree().create_timer(5.0).timeout
	var battle_scene := get_tree().current_scene as BattleScene
	assert(battle_scene != null)
	
	var hand_has_cards: bool = true
	while hand_has_cards:
		
		var cards = battle_scene.battle_flow_manager.play_hand.get_children()
		battle_scene.player.resolve_card(
			cards[0], 
			battle_scene.battle_flow_manager.play_hand.resolver, 
			battle_scene.battle_flow_manager.play_hand
		)
		print("Playing: \"" + cards[0].instance.data.name + "\"")
		
		if cards.size() == 1:
			hand_has_cards = false
		
		battle_scene.battle_flow_manager.play_hand.confirm_play(cards[0])
		await get_tree().create_timer(0.5).timeout
		
		if battle_scene.battle_flow_manager.player.cards.draw_pile.size() > 0:
			battle_scene.battle_flow_manager.player.cards.draw_cards(1)
	print("All cards played successfully.")
