extends Node

@onready var encounter_res: EnemyEncounter = preload("res://testing_and_prototypes/automated_tests/battle_tests/AllMonstersAutomatedTest/associated_resources/all_monsters_encounter.tres")
@onready var player_res: PlayerData = preload("res://testing_and_prototypes/automated_tests/battle_tests/AllMonstersAutomatedTest/associated_resources/all_monsters_player.tres")
@onready var progress_res: RunProgress = preload("res://testing_and_prototypes/automated_tests/battle_tests/AllMonstersAutomatedTest/associated_resources/all_monsters_progress.tres")
@onready var field_res: BattleFieldConfig = preload("res://testing_and_prototypes/automated_tests/battle_tests/AllMonstersAutomatedTest/associated_resources/all_monsters_field.tres")

@export var all_monsters: Array[MonsterData]

var test_enabled: bool = false

# MANUAL TEST ENEMIES:  FIRE ANT EGG, MIMIC
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
	
	await get_tree().create_timer(0.5).timeout
	for i in range(0, all_monsters.size()):
		battle_scene.creature_manager.spawn_enemy(all_monsters[i])
		var curr_enemy: MonsterEntity = battle_scene.creature_manager.enemies[1]
		print("Testing: ", curr_enemy.data.name)
		await get_tree().create_timer(0.5).timeout
		for j in range(0, all_monsters[i].move_sequences.size()):
			curr_enemy.move_sequence = all_monsters[i].move_sequences[j]
			for k in curr_enemy.move_sequence.moves.size():
				curr_enemy.move_index = k
				curr_enemy.intent = curr_enemy.move_sequence.moves[curr_enemy.move_index]
				await curr_enemy.resolve_intent(
					battle_scene.battle_flow_manager.action_resolver
				)
				await get_tree().create_timer(0.5).timeout
				for l in range(battle_scene.creature_manager.enemies.size() - 1, -1, -1):
					if battle_scene.creature_manager.enemies[l].data.name != "All Monsters Monster" && battle_scene.creature_manager.enemies[l].data.name != curr_enemy.data.name:
						battle_scene.creature_manager.enemies[l].health.kill()
		if !battle_scene.battle_flow_manager.action_resolver.action_queue.queue.is_empty():
			await battle_scene.battle_flow_manager.action_resolver.action_queue.processed_all_actions
		if is_instance_valid(curr_enemy):
			curr_enemy.health.kill()
		await get_tree().create_timer(0.5).timeout
	print("All monster move sequences executed successfully.")
