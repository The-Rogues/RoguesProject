extends Node2D
class_name BattleFlowManager

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


func initialize(context:BattleContext):
	battle_state = State.START
	
	action_resolver = ActionResolver.new(context)
	player = context.creature_manager.player
	enemies = context.creature_manager.enemies
	battle_field = context.battle_field
	rewards_screen = context.reward_handler
	
	context.creature_manager.all_enemies_defeated.connect(_on_battle_ended)
	context.creature_manager.player_defeated.connect(_on_battle_ended)


func start_battle():
	if battle_state == State.START:
		await turn_banner.display("Battle Start")
		
		battle_field.move_player(player, player.battle_position)
		start_player_turn()


func start_player_turn():
	if battle_state == State.ENDED:
		return
	
	turn_count += 1
	
	await turn_banner.display("Player Turn\nTurn: " + str(turn_count))
	
	player.enter_turn()
	
	for enemy in enemies:
		enemy.choose_intent()
	
	battle_field.enter_turn()
	
	player.cards.draw_cards(5)
	
	end_turn_button.disabled = false
	end_turn_button.text = "End Turn."


func end_player_turn():
	if battle_state == State.ENDED:
		return
	
	for enemy in enemies:
		enemy.enter_turn()
	
	end_turn_button.disabled = true
	end_turn_button.text = "Enemy Turn."
	player.cards.move_draw_into_discard_pile()
	play_hand.clear_hand()
	
	await get_tree().create_timer(1).timeout
	run_enemy_turn()


func run_enemy_turn():
	if battle_state == State.ENDED:
		return
	
	await turn_banner.display("Enemy Turn") 
	
	for enemy in enemies:
		await enemy.resolve_intent(action_resolver)
		
		enemy_attack_delay.start()
		await enemy_attack_delay.timeout
	
	await get_tree().create_timer(1).timeout
	
	start_player_turn()


func _on_battle_ended():
	battle_state = State.ENDED
	
	await get_tree().create_timer(1).timeout
	
	if !player.health.is_alive:
		defeat_screen.initialize()
		defeat_screen.visible = true
	else:
		rewards_screen.initialize()
		rewards_screen.visible = true
