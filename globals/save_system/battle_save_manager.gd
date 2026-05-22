extends Node
class_name BattleSaveManager


func has_battle_save(run: RunProgress) -> bool:
	return run != null \
		and run.battle != null \
		and run.battle.is_active \
		and run.battle.enemy_states.size() > 0


func ensure_battle_save(run: RunProgress) -> BattleSaveData:
	if run.battle == null:
		run.battle = BattleSaveData.new()
	return run.battle


func save_battle(scene: BattleScene) -> void:
	var run: RunProgress = GlobalSessionManager.run_progress
	if run == null:
		return

	var battle_save := ensure_battle_save(run)
	battle_save.is_active = true

	save_enemy_states(scene, battle_save)
	save_object_states(scene, battle_save)
	save_player_position(scene, battle_save)
	save_card_piles(scene, battle_save)
	save_effects(scene, battle_save)
	save_player_energy(scene, battle_save)

	GlobalSaveManager.save_run(run)


func restore_battle(scene: BattleScene, run: RunProgress) -> void:
	if run == null or run.battle == null:
		return

	var battle_save := run.battle

	restore_enemies(scene, battle_save)
	restore_objects(scene, battle_save)
	restore_card_piles(scene, battle_save)
	restore_effects(scene, battle_save)
	restore_player_energy(scene, battle_save)


func clear_battle_save(run: RunProgress) -> void:
	if run == null:
		return

	run.battle = null
	run.room_in_progress = false
	run.pending_node_index = -1
	run.pending_room_type = -1

	GlobalSaveManager.save_run(run)


# --------------------------------------------------
# Save
# --------------------------------------------------

func save_enemy_states(scene: BattleScene, battle_save: BattleSaveData) -> void:
	battle_save.enemy_states.clear()

	for enemy in scene.creature_manager.enemies:
		var state := MonsterSaveData.new()
		state.monster_data = enemy.data
		state.current_health = enemy.health.value
		state.max_health = enemy.health.max_value
		state.move_index = enemy.move_index
		state.intent = enemy.intent
		state.move_sequence = enemy.move_sequence
		battle_save.enemy_states.append(state)


func save_object_states(scene: BattleScene, battle_save: BattleSaveData) -> void:
	battle_save.object_states.clear()

	for i in range(scene.battle_field.battle_positions.size()):
		var obj: ObjectEntity = scene.battle_field.battle_positions[i].get_object()

		if obj == null:
			continue

		var state := ObjectSaveData.new()
		state.object_data = obj.data
		state.current_health = obj.health.value
		state.position_index = i
		battle_save.object_states.append(state)


func save_player_position(scene: BattleScene, battle_save: BattleSaveData) -> void:
	for i in range(scene.battle_field.battle_positions.size()):
		if scene.battle_field.battle_positions[i] == scene.player.battle_position:
			battle_save.player_position_index = i
			return


func save_card_piles(scene: BattleScene, battle_save: BattleSaveData) -> void:
	battle_save.draw_pile = serialize_card_pile(scene.player.cards.draw_pile)
	battle_save.discard_pile = serialize_card_pile(scene.player.cards.discard_pile)
	battle_save.exhaust_pile = serialize_card_pile(scene.player.cards.exhaust_pile)
	battle_save.drawn_pile = serialize_card_pile(scene.player.cards.drawn_cards)


func serialize_card_pile(pile: Array[CardInstance]) -> Array[CardInstanceSaveData]:
	var result: Array[CardInstanceSaveData] = []

	for card in pile:
		var state := CardInstanceSaveData.new()
		state.card_data = card.data
		state.energy_cost = card.energy_cost
		result.append(state)

	return result


func save_effects(scene: BattleScene, battle_save: BattleSaveData) -> void:
	var data := BattleEffectsSaveData.new()

	data.player_block = scene.player.block.value

	for effect in scene.player.effects.active_effects:
		var state := StatusEffectSaveData.new()
		state.behaviour = effect.effect
		state.duration = effect.duration
		state.stack = effect.stack
		state.turn_entered = effect.turn_entered
		data.player_status_effects.append(state)

	for enemy in scene.creature_manager.enemies:
		data.enemy_blocks.append(enemy.block.value)
		data.enemy_effect_counts.append(enemy.effects.active_effects.size())

		for effect in enemy.effects.active_effects:
			var state := StatusEffectSaveData.new()
			state.behaviour = effect.effect
			state.duration = effect.duration
			state.stack = effect.stack
			state.turn_entered = effect.turn_entered
			data.enemy_status_effects.append(state)

	for i in range(scene.battle_field.battle_positions.size()):
		var effect: PositionEffect = scene.battle_field.battle_positions[i].get_effect()

		if effect == null:
			continue

		var state := PositionEffectSaveData.new()
		state.config = effect.data
		state.duration = effect.duration
		state.stack = effect.stack
		state.position_index = i
		data.position_effects.append(state)

	battle_save.effects = data


func save_player_energy(scene: BattleScene, battle_save: BattleSaveData) -> void:
	battle_save.player_energy = scene.player.energy.value
	battle_save.player_max_energy = scene.player.energy.max_value
	battle_save.player_bonus_energy = scene.player.energy.bonus_energy


# --------------------------------------------------
# Restore
# --------------------------------------------------

func restore_enemies(scene: BattleScene, battle_save: BattleSaveData) -> void:
	scene.creature_manager.player = scene.player
	scene.player.defeated.connect(scene.creature_manager._on_creature_defeated)

	for state in battle_save.enemy_states:
		scene.creature_manager.spawn_enemy_from_save(state)


func restore_objects(scene: BattleScene, battle_save: BattleSaveData) -> void:
	for state in battle_save.object_states:
		var pos: BattlePosition = scene.battle_field.battle_positions[state.position_index]
		scene.battle_field.place_object(state.object_data, pos)

		var obj: ObjectEntity = pos.get_object()
		if obj != null:
			obj.health.initialize(state.current_health, state.object_data.health)


func restore_card_piles(scene: BattleScene, battle_save: BattleSaveData) -> void:
	restore_card_pile(battle_save.draw_pile, scene.player.cards.draw_pile)
	restore_card_pile(battle_save.discard_pile, scene.player.cards.discard_pile)
	restore_card_pile(battle_save.exhaust_pile, scene.player.cards.exhaust_pile)
	restore_card_pile(battle_save.drawn_pile, scene.player.cards.drawn_cards)


func restore_card_pile(saved: Array[CardInstanceSaveData], target: Array[CardInstance]) -> void:
	target.clear()

	for state in saved:
		var instance := CardInstance.new(state.card_data)
		instance.energy_cost = state.energy_cost
		target.append(instance)


func restore_effects(scene: BattleScene, battle_save: BattleSaveData) -> void:
	if battle_save.effects == null:
		return

	var fx := battle_save.effects

	scene.player.block.value = fx.player_block

	for state in fx.player_status_effects:
		scene.player.effects.add_effect(
			state.behaviour,
			state.duration,
			state.stack,
			state.turn_entered,
			true
		)

	var effect_idx := 0

	for i in range(scene.creature_manager.enemies.size()):
		if i >= fx.enemy_effect_counts.size():
			break

		if i < fx.enemy_blocks.size():
			scene.creature_manager.enemies[i].block.value = fx.enemy_blocks[i]

		var count: int = fx.enemy_effect_counts[i]

		for j in range(count):
			if effect_idx >= fx.enemy_status_effects.size():
				break

			var state: StatusEffectSaveData = fx.enemy_status_effects[effect_idx]
			scene.creature_manager.enemies[i].effects.add_effect(
				state.behaviour,
				state.duration,
				state.stack,
				state.turn_entered,
				true
			)

			effect_idx += 1

	for state in fx.position_effects:
		var pos: BattlePosition = scene.battle_field.battle_positions[state.position_index]
		pos.add_position_effect(state.config)

		if pos.get_effect() != null:
			pos.get_effect().duration = state.duration
			pos.get_effect().stack = state.stack


func restore_player_energy(scene: BattleScene, battle_save: BattleSaveData) -> void:
	scene.player.energy.set_energy(
		battle_save.player_energy,
		battle_save.player_max_energy
	)

	scene.player.energy.bonus_energy = battle_save.player_bonus_energy
