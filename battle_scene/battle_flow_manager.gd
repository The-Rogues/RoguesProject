extends Node2D
class_name BattleFlowManager
## Responsible for executing player and enemy turn logic. Also handles turn
## transitions and ending battles.

signal turn_entered

# Used to prevent some functions from execution if the battle is in a different state
enum State {START, PLAYER_TURN, ENEMY_TURN, ENDED}
var battle_state:State = State.START

@export var defeat_screen:DefeatedScreen
@export var play_hand:PlayerCardHand
@export var turn_banner: BannerPopup
@export var end_turn_button: Button
@onready var enemy_attack_delay: Timer = $EnemyAttackDelay

var player:PlayerEntity
var enemies:Array[MonsterEntity]
var battle_field:BattleField
var rewards_screen:BattleRewardsHandler
var action_resolver: ActionResolver
var turn_count:int = 0
var context:BattleContext = null
var battle_powers:BattlePowersManager
var resuming: bool = false


func initialize(_context:BattleContext, _resuming: bool = false ):
	battle_state = State.START
	resuming = _resuming
	
	# If we quit after enemy turn, need to draw cards on resume
	if _resuming:
		var run : RunProgress = GlobalSessionManager.run_progress
		if run != null and run.battle != null and run.battle.battle_state == 1:
			resuming = false  


	context = _context
	action_resolver = ActionResolver.new(_context)
	battle_powers = BattlePowersManager.new()
	player = _context.creature_manager.player
	apply_innate_effects(context)
	enemies = _context.creature_manager.enemies
	battle_field = _context.battle_field
	rewards_screen = _context.reward_handler
	
	_context.resolve_targeting = action_resolver.resolve_targeting
	_context.add_power = battle_powers.add_power
	
	_context.creature_manager.all_enemies_defeated.connect(_on_battle_ended)
	_context.creature_manager.player_defeated.connect(_on_battle_ended)


func start_battle():
	if battle_state == State.START:
		await turn_banner.display("Battle Start")
		
		battle_field.move_player(player, player.battle_position)
		player.unused_energy_last_turn = 0
		player.damage_taken_this_turn = 0
		player.damage_taken_last_turn = 0
		player.attacked_this_turn = true
		player.attacked_last_turn = true
		start_player_turn()


func start_player_turn():
	if battle_state == State.ENDED:
		return
	context.is_player_turn = true
	
	turn_count += 1
	turn_entered.emit()
	
	await turn_banner.display("Player Turn\nTurn: " + str(turn_count))
	
	if turn_count == 1:
		player.enter_turn(turn_count, true)
	else:
		player.enter_turn(turn_count, false)
	manage_effects(true)
	
	for enemy in enemies:
		enemy.choose_intent()
	
	# Fletcher - Updates calculated targeting after enemies have chosen new moves.
	context.creature_manager.update_attack_targeting()
	context.battle_field.update_preferences(player)
	
	battle_field.enter_turn(turn_count, player)
	
	battle_powers.enter_turn(context)
	
	if resuming:
		resuming = false  # only skip once, normal from turn 2 onwards
	else:
		player.cards.draw_cards(5)
		_save_battle_state()
	
	end_turn_button.disabled = false
	end_turn_button.text = "End Turn"


func end_player_turn():
	if battle_state == State.ENDED:
		return
	context.is_player_turn = false
	
	battle_field.decay_position_effects()
	battle_powers.end_turn(context)
	
	for enemy in enemies:
		enemy.enter_turn(turn_count)
	manage_effects(false)
	
	battle_field.end_turn(turn_count, player)
	
	#player.effects.decay_status_effects(false)
	end_turn_button.disabled = true
	end_turn_button.text = "Enemy Turn."
	player.cards.move_draw_into_discard_pile()
	play_hand.clear_hand()
	
	_save_battle_state()
	# Mark that enemy turn is about to start
	var run : RunProgress = GlobalSessionManager.run_progress
	if run != null and run.battle != null:
		run.battle.battle_state = 1
		GlobalSaveManager.save_run(run)
	
	await get_tree().create_timer(1).timeout
	run_enemy_turn()


func run_enemy_turn():
	if battle_state == State.ENDED:
		return
	context.is_player_turn = false
	
	await turn_banner.display("Enemy Turn") 
	
	var processed_enemies: Array[MonsterEntity] = []
	var curr_enemy_idx: int = 0
	while curr_enemy_idx < enemies.size():
		if !processed_enemies.has(enemies[curr_enemy_idx]):
			var curr_enemy: MonsterEntity =  enemies[curr_enemy_idx]
			await curr_enemy.resolve_intent(action_resolver)
			if !action_resolver.action_queue.queue.is_empty() || action_resolver.action_queue.processing_action:
				await action_resolver.action_queue.processed_all_actions
			if is_instance_valid(curr_enemy) && enemies.has(curr_enemy):
				processed_enemies.append(curr_enemy)
			curr_enemy_idx = 0
			enemy_attack_delay.start()
			await enemy_attack_delay.timeout
			continue
		curr_enemy_idx += 1
	
	if !action_resolver.action_queue.queue.is_empty() || action_resolver.action_queue.processing_action:
		await action_resolver.action_queue.processed_all_actions
	await get_tree().create_timer(1.0).timeout
	
	
	_save_battle_state()
	# Mark that player turn is about to start
	var run : RunProgress = GlobalSessionManager.run_progress
	if run != null and run.battle != null:
		run.battle.battle_state = 0
		GlobalSaveManager.save_run(run)
	start_player_turn()


func _on_battle_ended():
	battle_state = State.ENDED
	
	play_hand.clear_hand()
	add_gem_reward()
	player.effects.active_effects.clear()
	
	GlobalSessionManager.run_progress.player_data.personality.reset_trait_overrides()
	GlobalSessionInterface.disconnect_from_player(player)
	GlobalSessionInterface.reset_stats_to_base_display()
	
	MusicManager.stop()
	await get_tree().create_timer(2).timeout
	
	if !player.health.is_alive:
		MusicManager.change_song(MusicManager.track_list.defeated_theme)
		defeat_screen.initialize()
		defeat_screen.visible = true
	else:
		rewards_screen.initialize()
		MusicManager.change_song(MusicManager.track_list.victory_theme)
		rewards_screen.visible = true

func add_gem_reward():
	var gem_behavior: GemEffect = load("res://content/cards/greedy_cards/gem_behavior/gem_behavior.tres")
	var num_gems: int = 0
	for i in range(0, player.effects.active_effects.size()):
		if player.effects.active_effects[i].effect == gem_behavior:
			num_gems = player.effects.active_effects[i].stack
	if num_gems >= 5:
		context.reward_handler.add_reward(load(
			"res://content/cards/greedy_cards/gem_reward/gem_gold_reward.tres"
		))

func manage_effects(player_turn_entered: bool):
	player.effects.on_turn(player_turn_entered)
	player.effects.decay_status_effects(player_turn_entered)
	for i in range(enemies.size() - 1, -1, -1):
		var curr_enemy: MonsterEntity = enemies[i]
		curr_enemy.effects.on_turn(!player_turn_entered)
		curr_enemy.effects.decay_status_effects(!player_turn_entered)

func apply_innate_effects(in_context: BattleContext):
	battle_powers.add_power(load("res://content/cards/naive_cards/practice_makes_perfect/practice_perfect_power.tres"), in_context)
	battle_powers.add_power(load("res://content/cards/vengeful_cards/retaliate_power/retaliate_power.tres"), in_context)
	battle_powers.add_power(load("res://content/cards/brute_cards/rage_effect/rage_manager_instance.tres"), in_context)
	battle_powers.add_power(load("res://content/cards/valorous_cards/final_surge/final_surge_power_instance.tres"), in_context)
	
func _save_battle_state() -> void:
	var scene = get_tree().current_scene
	if scene is BattleScene:
		scene._save_enemy_states()
		scene._save_object_states()
		scene._save_player_position()
		scene._save_card_piles()
		scene._save_all_effects()
		scene._save_player_energy()
		scene._save_rewards() 
	
