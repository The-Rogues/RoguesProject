extends Node

@onready var encounter_res: EnemyEncounter = preload("res://testing_and_prototypes/automated_tests/battle_tests/AiTimedAutomatedTest/associated_resources/ai_timed_encounter.tres")
@onready var player_res: PlayerData = preload("res://testing_and_prototypes/automated_tests/battle_tests/AiTimedAutomatedTest/associated_resources/ai_timed_player.tres")
@onready var progress_res: RunProgress = preload("res://testing_and_prototypes/automated_tests/battle_tests/AiTimedAutomatedTest/associated_resources/ai_timed_progress.tres")
@onready var field_res: BattleFieldConfig = preload("res://testing_and_prototypes/automated_tests/battle_tests/AiTimedAutomatedTest/associated_resources/ai_timed_battle_field.tres")

var num_iterations: int = 20
var ai_cards: Array[AiCardData] = [
	#preload("res://ai/ai-cards/invent_defend/invent_defend.tres"),
	#preload("res://ai/ai-cards/invent_melee/invent_melee.tres"),
	#preload("res://ai/ai-cards/invent_move/invent_move.tres"),
	preload("res://ai/ai-cards/invent_ranged/invent_ranged.tres"),
	#preload("res://ai/ai-cards/invent_tool/invent_tool.tres")
]
var personality_traits: Array[PersonalityTrait] = [
	preload("res://content/personality_traits/brutish.tres"),
	preload("res://content/personality_traits/merciful.tres"),
	preload("res://content/personality_traits/vengeful.tres"),
	preload("res://content/personality_traits/tactical.tres"),
	preload("res://content/personality_traits/crafty.tres"),
	preload("res://content/personality_traits/skittish.tres"),
	preload("res://content/personality_traits/stoic.tres"),
	preload("res://content/personality_traits/naive.tres"),
	preload("res://content/personality_traits/valorous.tres"),
	preload("res://content/personality_traits/greedy.tres"),
	preload("res://content/personality_traits/laidback.tres"),
	preload("res://content/personality_traits/friendly.tres")
]
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
	
	var player_entity: PlayerEntity = battle_scene.battle_flow_manager.player
	var avg_time: int = 0
	var time_errors: int = 0
	var total_errors: int = 0
	var total_error_counted: bool = false
	var generation_errors: int = 0
	for i in range(0, num_iterations):
		for j in range(0, ai_cards.size()):
			
			total_error_counted = false
			
			var curr_card: CardInstance = CardInstance.new(ai_cards[j])
			player_entity.cards.add_card_to_draw_pile(
				curr_card, 
				true
			)
			player_entity.cards.draw_cards(1)
			await get_tree().create_timer(0.25).timeout
			
			var cards = battle_scene.battle_flow_manager.play_hand.get_children()
			print("Playing: \"" + cards[0].instance.data.name + "\" (Iteration: " + str(i) + ")")
			randomize_personality()
			var start_time := Time.get_ticks_msec()
			player_entity.resolve_card(
				cards[0], 
				battle_scene.battle_flow_manager.play_hand.resolver, 
				battle_scene.battle_flow_manager.play_hand
			)
			await player_entity.end_ai_processing
			var stop_time: int = Time.get_ticks_msec()
			avg_time += stop_time - start_time
			
			if ((stop_time - start_time) / 1000.0) > 15.0:
				time_errors += 1
				total_errors += 1
				total_error_counted = true
			
			cards = battle_scene.battle_flow_manager.play_hand.get_children()
			if generated_error_card(ai_cards[j], cards[0], ai_cards[j].gen_callback):
				generation_errors += 1
				if !total_error_counted:
					total_errors += 1
			
			await get_tree().create_timer(0.25).timeout
			player_entity.cards.move_draw_into_discard_pile()
			battle_scene.battle_flow_manager.play_hand.clear_hand()
		
	print("Final Results: ")
	print("- Average Time: " + str((avg_time * 1.0) / (num_iterations * ai_cards.size() * 1000)) + " seconds.")
	print("- Time Error Rate: " + str((time_errors * 1.0) / (num_iterations * ai_cards.size())))
	print("- Generation Error Rate: " + str((generation_errors * 1.0) / (num_iterations * ai_cards.size())))
	print("- Total Error Rate: " + str(((total_errors) * 1.0) / (num_iterations * ai_cards.size())))

func randomize_personality() -> void:
	for i in range(0, 3):
		var personality_start: int = i * 4
		match i:
			0:
				player_res.personality.offensive_trait = personality_traits[personality_start + randi_range(0, 3)]
				player_res.personality.offensive_weight = randi_range(1, 10)
			1:
				player_res.personality.defensive_trait = personality_traits[personality_start + randi_range(0, 3)]
				player_res.personality.defensive_weight = randi_range(1, 10)
			2:
				player_res.personality.strategic_trait = personality_traits[personality_start + randi_range(0, 3)]
				player_res.personality.strategic_weight = randi_range(1, 10)

func generated_error_card(orig_data: AiCardData, created_card: Card, gen_script: Script):
	var gen_instance: RefCounted = gen_script.new()
	var pass_arr: Array[int] = []
	var ref_card: CardData = gen_instance.create_card(orig_data, pass_arr)
	if ref_card.energy_cost == created_card.instance.data.energy_cost && ref_card.description == created_card.instance.data.description:
		return true
	return false
