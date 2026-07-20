# ==========================================================
# Authors: Fabian, Han
# Description:
#   Initializes battle scene given configuration settings
#
# ==========================================================

extends Node2D
class_name BattleScene

# Systems
@export var battle_field:BattleField
@export var creature_manager:CreatureManager
@export var rewards_screen: BattleRewardsHandler
@export var play_hand: PlayerCardHand
@export var battle_flow_manager: BattleFlowManager
@export var player:PlayerEntity
@export var defeat_screen: DefeatedScreen


# UI
@export var energy_ui: EnergyUI
@export var draw_pile_icon: Control
@export var discard_pile_icon: Control
@export var draw_pile_viewer: CardViewer
@export var discard_pile_viewer: CardViewer
@export var preference_button: Button

@onready var boss_dialogue_box: BossDialogueBox = $UILayer/BossDialogueBox

func _ready() -> void:
	var config = GlobalSceneLoader.battle_config
	if config:
		initialize(config)


func initialize(battle_config: BattleConfig):
	var run: RunProgress = GlobalSessionManager.run_progress
	var resuming := run != null and run.battle != null \
		and run.battle.enemy_states.size() > 0
		
	# initialize player
	player.initialize(battle_config.player_data, resuming)
	energy_ui.initialize(player.energy)
	
	if resuming:
		_restore_battle(run)
	else:
		creature_manager.initialize(player, battle_config.enemy_encounter.enemies)
		battle_field.setup_objects(battle_config.battle_field_config)
	
	#andy addition
	for enemy in creature_manager.enemies:
		enemy.defeated.connect(_on_enemy_defeated)
	#end
	
	# Rewards
	if !resuming: 
		for reward in battle_config.enemy_encounter.get_battle_rewards():
			rewards_screen.add_reward(reward)
	
	# Player position
	if resuming:
		player.battle_position = battle_field.battle_positions[
			run.battle.player_position_index
		]
		player.battle_position.on_player_entered(player)
	else:
		player.battle_position = battle_field.battle_positions[
			roundi(battle_field.battle_positions.size()/2)
		]
	
	# Player appearance
	player.movement_controller.battle_field = battle_field
	#if run != null:
	#	player.sprite_2d.texture = GlobalSessionManager.run_progress.player_texture
	#	player.melee_weapon_sprite.texture = GlobalSessionManager.run_progress.player_melee_weapon_texture
	#	player.ranged_weapon_sprite.texture = GlobalSessionManager.run_progress.player_ranged_weapon_texture
	
	# Initialize systems
	var battle_context := BattleContext.new(
		creature_manager,
		battle_field,
		rewards_screen
	)
	
	battle_flow_manager.initialize(battle_context, resuming)
	play_hand.initialize(player, battle_flow_manager.action_resolver)
	
			
	battle_field.object_interacted.connect(
		battle_flow_manager.action_resolver.process_actions)
	
	# Connect signals
	player.cards.draw_pile_updated.connect(draw_pile_icon._on_card_pile_updated)
	player.cards.draw_pile_updated.connect(draw_pile_viewer.on_cards_updated)
	player.cards.discard_pile_updated.connect(discard_pile_icon._on_card_pile_updated)
	player.cards.discard_pile_updated.connect(discard_pile_viewer.on_cards_updated)
	battle_field.object_placed.connect(creature_manager.add_object_enemy)
	
	# TODO: Figure out cleaner way to avoid hard-coding
	creature_manager.defeated_mimic.connect(func():
		var mimic_reward = load("res://content/objects/object_reward_resources/chest_reward.tres")
		battle_flow_manager.action_resolver.process_actions(
			[mimic_reward],
			null
		)
		)
	
	# Update pile UI when resume
	if resuming:
		draw_pile_icon._on_card_pile_updated(player.cards.draw_pile)
		discard_pile_icon._on_card_pile_updated(player.cards.discard_pile)
		draw_pile_viewer.on_cards_updated(player.cards.draw_pile)
		discard_pile_viewer.on_cards_updated(player.cards.discard_pile)
	
	GlobalSessionInterface.connect_to_player(player)
	GameStats.initialize_battle(battle_config.enemy_encounter, battle_flow_manager)
	#andy addition:
	for enemy in creature_manager.enemies:
		if enemy.data.name == "Arbitor":
			boss_dialogue_box.start_dialogue("Arbitor", ["Show me who you are!"])
			
		
	#end of andy
	battle_flow_manager.start_battle()
	MusicManager.change_song(MusicManager.track_list.choose_battle_theme())
	
	if resuming and run.battle.battle_state == 0:
		await get_tree().process_frame
		for card in player.cards.drawn_cards:
			player.cards.drew_card.emit(card)
			
	# Only save initial state on fresh battle
	if !resuming:
		save_battle_state()

#---------------------------------------------------
# UI Callbacks
#---------------------------------------------------


func _on_view_draw_pile_button_up() -> void:
	draw_pile_viewer.visible = true
	pass # Replace with function body.


func _on_view_discard_pile_button_up() -> void:
	discard_pile_viewer.visible = true
	pass # Replace with function body.


func _on_preference_button_pressed() -> void:
	creature_manager.toggle_preferences()
	creature_manager.show_preferences = !creature_manager.show_preferences
	battle_field.toggle_preferences()
	battle_field.show_preferences = !battle_field.show_preferences


#---------------------------------------------------
# Save
#---------------------------------------------------

# TODO: Save battle powers. Save objects whose HP has changed properly.
func save_battle_state() -> void:
	_save_enemy_states()
	_save_object_states()
	_save_card_piles()
	_save_player_position()
	_save_all_effects()
	_save_player_energy()
	_save_rewards()
	_save_misc_player_trackers()

func _save_enemy_states() -> void:
	var run : RunProgress = GlobalSessionManager.run_progress
	if run == null or  run.battle == null:
		return
	run.battle.enemy_states.clear()
	for enemy in creature_manager.enemies:
		var state: MonsterSaveData = MonsterSaveData.new()
		state.monster_data = enemy.data
		state.current_health = enemy.health.value
		state.max_health = enemy.health.max_value
		state.move_index = enemy.move_index
		state.intent = enemy.intent
		state.move_sequence = enemy.move_sequence
		run.battle.enemy_states.append(state)
		
	GlobalSaveManager.save_run(run)

func _save_object_states() -> void:
	var run : RunProgress = GlobalSessionManager.run_progress
	if run == null or run.battle == null:
		return
	
	run.battle.object_states.clear()
	for i in range(0, battle_field.battle_positions.size()):
		var obj: ObjectEntity = battle_field.battle_positions[i].get_object()
		if obj == null:
			continue
			
		if obj.health.value <= 0:
			continue
			
		if obj != null:
			var state := ObjectSaveData.new()
			state.object_data = obj.data
			state.current_health = obj.health.value
			state.position_index = i
			run.battle.object_states.append(state)
	
	GlobalSaveManager.save_run(run)

func _save_player_position() -> void:
	var run : RunProgress = GlobalSessionManager.run_progress
	if run == null or run.battle == null:
		return
	
	for i in range(0, battle_field.battle_positions.size()):
		if battle_field.battle_positions[i] == player.battle_position:
			run.battle.player_position_index = i
			break
	
	GlobalSaveManager.save_run(run)
	
func _save_card_piles() -> void:
	var run : RunProgress = GlobalSessionManager.run_progress
	if run == null or run.battle == null:
		return
		
	run.battle.draw_pile = _serialize_card_pile(player.cards.draw_pile)
	run.battle.discard_pile = _serialize_card_pile(player.cards.discard_pile)
	run.battle.exhaust_pile = _serialize_card_pile(player.cards.exhaust_pile)
	run.battle.drawn_pile = _serialize_card_pile(player.cards.drawn_cards)
	
	GlobalSaveManager.save_run(run) 

func _serialize_card_pile(pile: Array[CardInstance]) -> Array[CardInstanceSaveData]:
	var result: Array[CardInstanceSaveData] = []
	for card in pile:
		var state := CardInstanceSaveData.new()
		state.card_data = card.data
		state.energy_cost = card.energy_cost
		result.append(state)
	return result

func _save_all_effects() -> void:
	var run : RunProgress = GlobalSessionManager.run_progress
	if run == null or run.battle == null:
		return
	
	var data := BattleEffectsSaveData.new()
	
	# Player
	data.player_block = player.block.value
	for effect in player.effects.active_effects:
		var state := StatusEffectSaveData.new()
		state.behaviour = effect.effect
		state.duration = effect.duration
		state.stack = effect.stack
		state.turn_entered = effect.turn_entered
		data.player_status_effects.append(state)
	
	# Enemies
	for enemy in creature_manager.enemies:
		data.enemy_blocks.append(enemy.block.value)
		data.enemy_effect_counts.append(enemy.effects.active_effects.size())
		for effect in enemy.effects.active_effects:
			var state := StatusEffectSaveData.new()
			state.behaviour = effect.effect
			state.duration = effect.duration
			state.stack = effect.stack
			state.turn_entered = effect.turn_entered
			data.enemy_status_effects.append(state)
	
	# Position effects
	for i in range(0, battle_field.battle_positions.size()):
		var effect: PositionEffect = battle_field.battle_positions[i].get_effect()
		if effect != null:
			var state := PositionEffectSaveData.new()
			state.config = effect.data
			state.duration = effect.duration
			state.stack = effect.stack
			state.position_index = i
			data.position_effects.append(state)
	
	run.battle.effects = data
	GlobalSaveManager.save_run(run)

func _save_player_energy() -> void:
	var run : RunProgress = GlobalSessionManager.run_progress
	if run == null or run.battle == null:
		return
	
	run.battle.player_energy = player.energy.value
	run.battle.player_max_energy = player.energy.max_value
	run.battle.player_bonus_energy = player.energy.bonus_energy
	
	GlobalSaveManager.save_run(run)
	
func _save_rewards() -> void:
	var run : RunProgress = GlobalSessionManager.run_progress
	if run == null or run.battle == null:
		return
	
	run.battle.pending_rewards = rewards_screen.rewards.duplicate()
	GlobalSaveManager.save_run(run)
#---------------------------------------------------
# Restore
#---------------------------------------------------
func _restore_battle(run: RunProgress) -> void:
	# Enemies
	creature_manager.player = player
	player.defeated.connect(creature_manager._on_creature_defeated)
	for state in run.battle.enemy_states:
			creature_manager.spawn_enemy_from_save(state)
			
	# Connect object_placed signals before restoring objects
	for pos in battle_field.battle_positions:
		if not pos.object_placed.is_connected(battle_field._on_object_placed):
			pos.object_placed.connect(battle_field._on_object_placed)
			
	# Objects
	for state in run.battle.object_states:
		var pos: BattlePosition = battle_field.battle_positions[state.position_index]
		battle_field.place_object(state.object_data, pos)
		var obj: ObjectEntity = pos.get_object()
		if obj != null:
			obj.health.initialize(state.current_health, state.object_data.health)
			

	# Card piles
	_restore_card_pile(run.battle.draw_pile, player.cards.draw_pile)
	_restore_card_pile(run.battle.discard_pile, player.cards.discard_pile)
	_restore_card_pile(run.battle.exhaust_pile, player.cards.exhaust_pile)
	_restore_card_pile(run.battle.drawn_pile, player.cards.drawn_cards)

	# Effects
	if run.battle.effects != null:
		_restore_effects(run.battle.effects)

	# Restore energy
	player.energy.set_energy(
		run.battle.player_energy,
		run.battle.player_max_energy
	)
	player.energy.bonus_energy = run.battle.player_bonus_energy
	_restore_misc_player_trackers()
	
	# Restore rewards
	for reward in run.battle.pending_rewards:
		rewards_screen.add_reward(reward)
	
	# Update targeting and preference displays after all state is restored
	creature_manager.update_attack_targeting()
	battle_field.update_preferences(player)

func _restore_card_pile(saved: Array[CardInstanceSaveData], target: Array[CardInstance]) -> void:
	for state in saved:
			var instance := CardInstance.new(state.card_data)
			instance.energy_cost = state.energy_cost
			target.append(instance)
	
func _restore_effects(fx: BattleEffectsSaveData) -> void:
	# Player
	player.block.set_block(fx.player_block) 
	for state in fx.player_status_effects:
		player.effects.add_effect(state.behaviour, state.duration,state.stack, state.turn_entered, true)

	# Enemy
	var effect_idx: int = 0
	for i in range(0, creature_manager.enemies.size()):
		if i >= fx.enemy_effect_counts.size():
			break
		if i < fx.enemy_blocks.size():
			creature_manager.enemies[i].block.set_block(fx.enemy_blocks[i])
			var count: int = fx.enemy_effect_counts[i]
			for j in range(0, count):
				if effect_idx >= fx.enemy_status_effects.size():
					break
				var state: StatusEffectSaveData = fx.enemy_status_effects[effect_idx]
				creature_manager.enemies[i].effects.add_effect(state.behaviour, state.duration, state.stack, state.turn_entered, true)
				effect_idx += 1

func _save_misc_player_trackers():
	var run : RunProgress = GlobalSessionManager.run_progress
	if run == null or run.battle == null:
		return
	
	run.battle.misc_attacked_last_turn = player.attacked_last_turn
	run.battle.misc_attacked_this_turn = player.attacked_this_turn
	run.battle.misc_cards_played_last_turn = player.cards_played_last_turn
	run.battle.misc_cards_played_this_turn = player.cards_played_this_turn
	run.battle.misc_damage_taken_last_turn = player.damage_taken_last_turn
	run.battle.misc_damage_taken_this_turn = player.damage_taken_this_turn
	run.battle.misc_strongest_attack_this_battle = player.strongest_attack_this_battle
	run.battle.misc_unused_energy_last_turn = player.unused_energy_last_turn
	GlobalSaveManager.save_run(run)

func _restore_misc_player_trackers():
	var run : RunProgress = GlobalSessionManager.run_progress
	if run == null or run.battle == null:
		return
	
	player.attacked_last_turn = run.battle.misc_attacked_last_turn
	player.attacked_this_turn = run.battle.misc_attacked_this_turn
	player.cards_played_last_turn = run.battle.misc_cards_played_last_turn
	player.cards_played_this_turn = run.battle.misc_cards_played_this_turn
	player.damage_taken_last_turn = run.battle.misc_damage_taken_last_turn
	player.damage_taken_this_turn = run.battle.misc_damage_taken_this_turn
	player.strongest_attack_this_battle = run.battle.misc_strongest_attack_this_battle
	player.unused_energy_last_turn = run.battle.misc_unused_energy_last_turn

#andy addition
func _on_enemy_defeated(enemy):
	if enemy.data.name == "Arbitor":
		boss_dialogue_box.start_dialogue("Arbitor",["So this is what remains..."])
