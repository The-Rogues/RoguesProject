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


func _ready() -> void:
	var config = GlobalSceneLoader.battle_config
	
	if config:
		initialize(config)
		
		


func initialize(battle_config:BattleConfig):
	# initialize player
	player.initialize(battle_config.player_data)
	energy_ui.initialize(player.energy)
	
	creature_manager.initialize(player, battle_config.enemy_encounter.enemies)
	battle_field.setup_objects(battle_config.battle_field_config)
	
	for reward in battle_config.enemy_encounter.get_battle_rewards():
		rewards_screen.add_reward(reward)
	
	player.battle_position = battle_field.battle_positions[
		roundi(battle_field.battle_positions.size()/2)
	]
	player.movement_controller.battle_field = battle_field
	
	#if GlobalSessionManager.run_progress:
	#	player.sprite_2d.texture = GlobalSessionManager.run_progress.player_texture
	#	player.melee_weapon_sprite.texture = GlobalSessionManager.run_progress.player_melee_weapon_texture
	#	player.ranged_weapon_sprite.texture = GlobalSessionManager.run_progress.player_ranged_weapon_texture
	
	var battle_context := BattleContext.new(
		creature_manager,
		battle_field,
		rewards_screen
	)
	
	battle_flow_manager.initialize(battle_context)
	
	play_hand.initialize(player, battle_flow_manager.action_resolver)
	battle_field.object_interacted.connect(
			battle_flow_manager.action_resolver.process_actions)
	
	# connect signals
	player.cards.draw_pile_updated.connect(draw_pile_icon._on_card_pile_updated)
	player.cards.draw_pile_updated.connect(draw_pile_viewer.on_cards_updated)
	player.cards.discard_pile_updated.connect(discard_pile_icon._on_card_pile_updated)
	player.cards.discard_pile_updated.connect(discard_pile_viewer.on_cards_updated)
	battle_field.object_placed.connect(creature_manager.add_object_enemy)
	
	GlobalSessionInterface.connect_to_player(player)
	
	battle_flow_manager.start_battle()
	
	MusicManager.change_song(MusicManager.track_list.choose_battle_theme())
	
	GameStats.initialize_battle(battle_config.enemy_encounter, battle_flow_manager)


func _setup_player_entity(data:PlayerData):
	player.initialize(data)
	
	player.cards.draw_pile_updated.connect(draw_pile_icon._on_card_pile_updated)
	player.cards.draw_pile_updated.connect(draw_pile_viewer.on_cards_updated)
	player.cards.discard_pile_updated.connect(discard_pile_icon._on_card_pile_updated)
	player.cards.discard_pile_updated.connect(discard_pile_viewer.on_cards_updated)
	
	GlobalSessionInterface.connect_to_player(player)


func _register_creatures():
	pass


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
