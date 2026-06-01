### game_statistics_manager.gd
### global GameStats
extends Node

@export var stats_data:GameStatsData
@export var battle_state:BattleStatsData


func _ready() -> void:
	stats_data = GlobalSaveManager.load_game_stats()
	
	if stats_data == null:
		stats_data = GameStatsData.new()
		stats_data.modified = true

	if battle_state == null:
		battle_state = BattleStatsData.new()

	connect_to_signals()


# -------------------------------------------------
# Signal Connections
# -------------------------------------------------

func connect_to_signals():
	# Lifetime/Profile Stats
	Events.run_completed.connect(_on_run_completed)
	Events.used_personality_trait.connect(_on_used_personality_trait)
	Events.personality_changed.connect(_on_personality_changed)
	Events.item_used.connect(_on_item_used)
	Events.chest_opened.connect(_on_chest_opened)
	Events.object_placed.connect(_on_object_placed)
	Events.gold_collected.connect(_on_gold_collected)
	Events.battle_won.connect(_on_battle_won)
	Events.card_collected.connect(_on_card_collected)

	# Battle Stats
	Events.turn_started.connect(_on_turn_started)
	Events.friend_summoned.connect(_on_friend_summoned)
	Events.energy_used.connect(_on_energy_used)


# -------------------------------------------------
# Battle State Management
# -------------------------------------------------

func initialize_battle(encounter:EnemyEncounter, battle:BattleFlowManager) -> void:
	reset_battle_state()
	battle_state.encounter = encounter
	battle_state.in_active_battle = true
	battle_state.turn_signal = battle.turn_entered
	battle_state.turn_signal.connect(on_battle_turn_entered)


func end_battle(player_state:PlayerEntity = null) -> void:
	Events.battle_won.emit(
		battle_state.encounter,
		player_state
	)
	
	if !stats_data.enemy_encounters_defeated.has(battle_state.encounter.encounter_name):
		stats_data.enemy_encounters_defeated.append(battle_state.encounter.encounter_name)
	
	battle_state.turn_signal.disconnect(on_battle_turn_entered)
	reset_battle_state(false)


func on_battle_turn_entered() -> void:
	reset_battle_state()
	battle_state.turn_count += 1


func reset_battle_state(keep_persistent_data:bool = true) -> void:
	battle_state.energy_used_in_turn = 0
	battle_state.friends_summoned_in_turn = 0
	battle_state.objects_placed_in_battle = 0
	
	if !keep_persistent_data:
		battle_state.encounter = null
		battle_state.in_active_battle = false
		battle_state.turn_count = 0
		battle_state.turn_signal = Signal()


# -------------------------------------------------
# Lifetime Statistics
# -------------------------------------------------

func _on_run_completed(summary:RunProgress):
	stats_data.runs_completed += 1


func _on_used_personality_trait(_trait:String):
	if !stats_data.personalities_used.has(_trait):
		stats_data.personalities_used.append(_trait)


func _on_personality_changed(_trait:String, weight:int):
	stats_data.personality_trait_shifts += 1

	if !stats_data.personalities_used.has(_trait):
		stats_data.personalities_used.append(_trait)


func _on_item_used(item:ItemData):
	stats_data.total_items_used += 1

	if !stats_data.used_items.has(item.name):
		stats_data.used_items.append(item.name)


func _on_chest_opened():
	stats_data.total_chests_opened += 1


func _on_object_placed(object:ObjectData):
	stats_data.total_objects_placed += 1

	# Battle-specific tracking
	battle_state.objects_placed_in_battle += 1


func _on_gold_collected(amount:int):
	stats_data.total_gold_collected += amount


func _on_battle_won(encounter:EnemyEncounter, player_state:PlayerEntity):
	if !stats_data.enemy_encounters_defeated.has(encounter.encounter_name):
		stats_data.enemy_encounters_defeated.append(encounter.encounter_name)


func _on_card_collected(card:CardData):
	if !stats_data.cards_collected.has(card.name):
		stats_data.cards_collected.append(card.name)


# -------------------------------------------------
# Battle Statistics
# -------------------------------------------------

func _on_turn_started(turn:int):
	battle_state.turn_count += 1
	battle_state.energy_used_in_turn = 0
	battle_state.friends_summoned_in_turn = 0


func _on_friend_summoned(friend:Friend):
	battle_state.friends_summoned_in_turn += 1


func _on_energy_used(amount:int):
	battle_state.energy_used_in_turn += amount
