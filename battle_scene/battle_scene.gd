# ==========================================================
# Authors: Fabian, Han
# Description:
#   Mediator between card input and battle manager
#   Executes visual turn transitions and calls results screen
#
# ==========================================================

extends Node2D
class_name BattleScene

# Systems
@export var battle_field:BattleField
@export var creature_manager:CreatureManager
@export var rewards_screen: BattleRewardsHandler
@export var turn_manager: BattleFlowManager
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


func _ready() -> void:
	var config = GlobalSceneLoader.battle_config
	if config:
		initialize(config)


func initialize(battle_config:BattleConfig):
	# initialize player
	player.initialize(battle_config.player_data)
	energy_ui.initialize(player.energy)
	
	creature_manager.initialize(player, battle_config.enemy_encounter.enemies)
	rewards_screen.add_reward(battle_config.enemy_encounter.get_gold_reward())
	battle_field.setup_objects(battle_config.battle_field_config)
	player.battle_position = battle_field.battle_positions[
		roundi(battle_field.battle_positions.size()/2)
	]
	player.movement_controller.battle_field = battle_field
	if GlobalSessionManager.run_progress:
		player.sprite_2d.texture = GlobalSessionManager.run_progress.player_texture
	
	var battle_context := BattleContext.new(
		creature_manager,
		battle_field,
		rewards_screen
	)
	
	battle_flow_manager.initialize(battle_context)
	play_hand.initialize(player, battle_flow_manager.action_resolver)
	
	# connect signals
	player.cards.draw_pile_updated.connect(draw_pile_icon._on_card_pile_updated)
	player.cards.draw_pile_updated.connect(draw_pile_viewer.on_cards_updated)
	player.cards.discard_pile_updated.connect(discard_pile_icon._on_card_pile_updated)
	player.cards.discard_pile_updated.connect(discard_pile_viewer.on_cards_updated)
	#player.cards.drew_card.connect(play_hand._on_card_drawn)
	
	GlobalSessionInterface.connect_to_player(player)
	
	turn_manager.start_battle()


func _on_view_draw_pile_button_up() -> void:
	draw_pile_viewer.visible = true
	pass # Replace with function body.


func _on_view_discard_pile_button_up() -> void:
	discard_pile_viewer.visible = true
	pass # Replace with function body.
