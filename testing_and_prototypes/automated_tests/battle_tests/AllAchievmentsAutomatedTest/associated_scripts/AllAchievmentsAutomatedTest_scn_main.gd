extends Node

@onready var encounter_res: EnemyEncounter = preload("res://testing_and_prototypes/automated_tests/battle_tests/AllAchievmentsAutomatedTest/associated_resources/achievments_encounter.tres")
@onready var player_res: PlayerData = preload("res://testing_and_prototypes/automated_tests/battle_tests/AllAchievmentsAutomatedTest/associated_resources/achievments_player.tres")
@onready var progress_res: RunProgress = preload("res://testing_and_prototypes/automated_tests/battle_tests/AllAchievmentsAutomatedTest/associated_resources/achievments_progress.tres")
@onready var field_res: BattleFieldConfig = preload("res://testing_and_prototypes/automated_tests/battle_tests/AllAchievmentsAutomatedTest/associated_resources/achievments_battle_field.tres")

var arsenal_card: CardData = preload("res://content/cards/vengeful_cards/arsenal.tres")
var frenzy_card: CardData = preload("res://content/cards/vengeful_cards/frenzy.tres")
var chest_opener: CardData = preload("res://content/cards/debug_cards/chest_opener/chest_opener.tres")
var monstermon_1: CardData = preload("res://content/cards/traitless_cards/snakio.tres")
var monstermon_2: CardData = preload("res://content/cards/traitless_cards/stinky.tres")
var monstermon_3: CardData = preload("res://content/cards/traitless_cards/mr_bat.tres")
var energy_potion: ItemData = preload("res://content/items/energy_potion/energy_potion.tres")
var metal_man: EnemyEncounter = preload("res://content/scene_configuration/enemy_encounters/special_encounters/the_metal_man.tres")

var unused_traits: Array[PersonalityTrait] = [
	preload("res://content/personality_traits/tactical.tres"),
	preload("res://content/personality_traits/merciful.tres"),
	preload("res://content/personality_traits/vengeful.tres"),
	preload("res://content/personality_traits/brutish.tres"),
	preload("res://content/personality_traits/stoic.tres"),
	preload("res://content/personality_traits/skittish.tres"),
	preload("res://content/personality_traits/naive.tres"),
	preload("res://content/personality_traits/crafty.tres"),
	preload("res://content/personality_traits/greedy.tres"),
	preload("res://content/personality_traits/laidback.tres"),
	preload("res://content/personality_traits/valorous.tres"),
	preload("res://content/personality_traits/friendly.tres")
]

var test_enabled: bool = false

func _ready():
	if !test_enabled:
		return
	
	GlobalSaveManager.reset()
	
	GlobalSessionManager.run_progress = progress_res
	GlobalSceneLoader.load_battle_scene()
	GlobalSceneLoader.battle_config = BattleConfig.new(
		encounter_res,
		field_res,
		player_res
	)
	GlobalSessionInterface.initialize()
	await get_tree().create_timer(5.0).timeout
	var battle_scene := get_tree().current_scene as BattleScene
	assert(battle_scene != null)
	
	# --Wonderful World--
	# --The Big Play--
	var hand_has_cards: bool = true
	while hand_has_cards:
		var cards = battle_scene.battle_flow_manager.play_hand.get_children()
		battle_scene.player.resolve_card(
			cards[0], 
			battle_scene.battle_flow_manager.play_hand.resolver, 
			battle_scene.battle_flow_manager.play_hand
		)
		
		if cards.size() == 1:
			hand_has_cards = false
		
		battle_scene.battle_flow_manager.play_hand.confirm_play(cards[0])
		await get_tree().create_timer(0.5).timeout
		
		if battle_scene.battle_flow_manager.player.cards.draw_pile.size() > 0:
			battle_scene.battle_flow_manager.player.cards.draw_cards(1)
	
	# --Treasure Hunter--
	battle_scene.player.cards.add_card_to_draw_pile(
		CardInstance.new(chest_opener), 
		true
	)
	battle_scene.player.cards.draw_cards(1)
	await get_tree().create_timer(0.25).timeout
			
	var chest_card_hand = battle_scene.battle_flow_manager.play_hand.get_children()
	battle_scene.player.resolve_card(
		chest_card_hand[0], 
		battle_scene.battle_flow_manager.play_hand.resolver, 
		battle_scene.battle_flow_manager.play_hand
	)
	await get_tree().create_timer(0.25).timeout
	
	# --Master Builder--
	for i in range(0, 4):
		
		var target_card: CardData
		if i % 2 == 0:
			target_card = arsenal_card
		else:
			target_card = frenzy_card
		
		var curr_card: CardInstance = CardInstance.new(target_card)
		battle_scene.player.cards.add_card_to_draw_pile(
			curr_card, 
			true
		)
		battle_scene.player.cards.draw_cards(1)
		await get_tree().create_timer(0.25).timeout
			
		var cards = battle_scene.battle_flow_manager.play_hand.get_children()
		battle_scene.player.resolve_card(
			cards[0], 
			battle_scene.battle_flow_manager.play_hand.resolver, 
			battle_scene.battle_flow_manager.play_hand
		)
		await get_tree().create_timer(0.25).timeout
	
	# --Material World--
	for i in range(0, 10):
		GlobalSessionManager.run_progress.player_data.add_item(energy_potion)
		await get_tree().create_timer(0.1).timeout
		GlobalSessionInterface.player_items.item_interface._automated_use_first_item()
		await get_tree().create_timer(0.1).timeout
	
	# --Inner Child--
	await get_tree().create_timer(0.5).timeout
	GlobalSessionManager.run_progress.player_data.add_card(monstermon_1)
	GlobalSessionManager.run_progress.player_data.add_card(monstermon_2)
	GlobalSessionManager.run_progress.player_data.add_card(monstermon_3)
	
	# --Cha-Ching!--
	await get_tree().create_timer(0.5).timeout
	GlobalSessionManager.run_progress.player_data.set_gold(10000)
	
	# --Empathic--
	await get_tree().create_timer(0.1).timeout
	GlobalSessionManager.run_progress.player_data.personality.set_trait("OFFENSIVE", unused_traits[0])
	GlobalSessionManager.run_progress.player_data.personality.set_trait("DEFENSIVE", unused_traits[4])
	GlobalSessionManager.run_progress.player_data.personality.set_trait("STRATEGIC", unused_traits[8])
	
	await get_tree().create_timer(0.1).timeout
	GlobalSessionManager.run_progress.player_data.personality.set_trait("OFFENSIVE", unused_traits[1])
	GlobalSessionManager.run_progress.player_data.personality.set_trait("DEFENSIVE", unused_traits[5])
	GlobalSessionManager.run_progress.player_data.personality.set_trait("STRATEGIC", unused_traits[9])
	
	await get_tree().create_timer(0.1).timeout
	GlobalSessionManager.run_progress.player_data.personality.set_trait("OFFENSIVE", unused_traits[2])
	GlobalSessionManager.run_progress.player_data.personality.set_trait("DEFENSIVE", unused_traits[6])
	GlobalSessionManager.run_progress.player_data.personality.set_trait("STRATEGIC", unused_traits[10])
	
	await get_tree().create_timer(0.1).timeout
	GlobalSessionManager.run_progress.player_data.personality.set_trait("OFFENSIVE", unused_traits[3])
	GlobalSessionManager.run_progress.player_data.personality.set_trait("DEFENSIVE", unused_traits[7])
	GlobalSessionManager.run_progress.player_data.personality.set_trait("STRATEGIC", unused_traits[11])
	
	# --Magic vs. Metal--
	# IMPORTANT: MUST CONFIRM THIS WORKS MANUALLY TOO.
	await get_tree().create_timer(0.5).timeout
	Events.battle_won.emit(metal_man, battle_scene.player)
	
	# --Journey's End--
	# IMPORTANT: MUST CONFIRM THIS WORKS MANUALLY TOO.
	await get_tree().create_timer(0.5).timeout
	Events.run_completed.emit(GlobalSessionManager.run_progress)
	
	await get_tree().create_timer(0.5).timeout
	print("\n--Manual Test Results--")
	print("Master Builder Completed: ", Achievements.achievements[0].completed)
	print("Magic vs. Metal Completed: ", Achievements.achievements[1].completed)
	print("Wonderful World Completed: ", Achievements.achievements[2].completed)
	print("Inner Child Completed: ", Achievements.achievements[3].completed)
	print("Material World Completed: ", Achievements.achievements[4].completed)
	print("Cha-Ching! Completed: ", Achievements.achievements[5].completed)
	print("Empathic Completed: ", Achievements.achievements[6].completed)
	print("The Big Play Completed: ", Achievements.achievements[7].completed)
	print("Treasure Hunter Completed: ", Achievements.achievements[8].completed)
	print("Journey's End Completed: ", Achievements.achievements[9].completed)
	print("\n")
