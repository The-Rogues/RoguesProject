extends Node

@onready var encounter: EnemyEncounter = preload("res://testing_and_prototypes/automated_tests/battle_tests/all_cards_encounter.tres")
@onready var player: PlayerData = preload("res://testing_and_prototypes/automated_tests/battle_tests/all_cards_player.tres")
@onready var progress: RunProgress = preload("res://testing_and_prototypes/automated_tests/battle_tests/new_resource.tres")
@onready var field: BattleFieldConfig = preload("res://testing_and_prototypes/automated_tests/battle_tests/all_cards_battle_field.tres")

func _ready():
	GlobalSessionManager.run_progress = progress
	GlobalSceneLoader.load_battle_scene()
	GlobalSceneLoader.battle_config = BattleConfig.new(
		encounter,
		field,
		player
	)
	await get_tree().create_timer(5.0).timeout
	var battle_scene := get_tree().current_scene as BattleScene
	assert(battle_scene != null)
	
	var hand_has_cards: bool = true
	while hand_has_cards:
		
		var cards = battle_scene.battle_flow_manager.play_hand.get_children()
		await battle_scene.player.resolve_card(
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
