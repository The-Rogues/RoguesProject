extends CanvasLayer
class_name SessionInterface

@onready var deck_ui: Control = $Control/Container/Treasure/DeckUI
@onready var player_items: PlayerItems = $Control/Container/Treasure/PlayerItems
@onready var gold_label: Label = $Control/Container/Treasure/Gold/GoldLabel
@onready var name_label: Label = $Control/Container/Stats/NameLabel
@onready var health_label: Label = $Control/Container/Stats/HealthLabel
@onready var offesnive_trait_display: TraitDisplay = $Control/Container/Stats/OffesniveTraitDisplay
@onready var defensive_trait_display: TraitDisplay = $Control/Container/Stats/DefensiveTraitDisplay
@onready var strategic_trait_display: TraitDisplay = $Control/Container/Stats/StrategicTraitDisplay
@onready var deck_viewer: CardViewer = $Control/DeckViewer
@onready var card_remover: CardRemover = $Control/CardRemover
@onready var card_picker: CardPicker = $Control/CardPicker
@onready var options_menu: OptionsMenu = $OptionsMenu
@onready var stat_modifier: Control = %StatModifier
@onready var modify_stat_button: Button = %ModifyStat
@onready var close_card_picker_button: Button = %CloseCardPicker
@onready var card_effects_manager: Control = %CardEffectsManager
@onready var generation_screen: Control = %GeneratingCardOverlay


func initialize():
	var run:RunProgress = GlobalSessionManager.run_progress
	
	run.player_data.cards_updated.connect(deck_ui._on_card_pile_updated)
	player_items.initialize()
	gold_label.initialize()
	name_label.text = run.player_data.name
	health_label.text = str(run.player_data.current_health) + "/" + str(run.player_data.max_health)
	
	
	#offesnive_trait_display.connect_to_data("OFFENSIVE", run.player_data.personality)
	#defensive_trait_display.connect_to_data("DEFENSIVE", run.player_data.personality)
	#strategic_trait_display.connect_to_data("STRATEGIC", run.player_data.personality)
	
	offesnive_trait_display._on_trait_data_updated(
		run.player_data.personality.offensive_trait,
		run.player_data.personality.offensive_weight
	)
	
	
	defensive_trait_display._on_trait_data_updated(
		run.player_data.personality.defensive_trait,
		run.player_data.personality.defensive_weight
	)
	
	strategic_trait_display._on_trait_data_updated(
		run.player_data.personality.strategic_trait,
		run.player_data.personality.strategic_weight
	)
	
	connect_to_personality_data(run.player_data.personality)
	
	deck_viewer.display_cards_from_data(run.player_data.cards)
	deck_ui._on_deck_updated(run.player_data.cards)
	
	run.player_data.cards_updated.connect(deck_ui._on_deck_updated)
	run.player_data.cards_updated.connect(deck_viewer.display_cards_from_data)
	run.player_data.card_collected.connect(func(card:CardData):
		card_effects_manager.add_card_effect(card, Vector2(725, 21)))
	run.player_data.card_removed.connect(func(card:CardData):
		card_effects_manager.remove_card_effect(card))
	#run.player_data.items_updated.connect(player_items._on_items_updated)
	run.player_data.health_updated.connect(_on_health_updated)


func connect_to_personality_data(personality:PersonalityData):
	personality.updated_offensive_trait.connect(
			offesnive_trait_display._on_trait_data_updated)
	
	personality.updated_defensive_trait.connect(
			defensive_trait_display._on_trait_data_updated)
	
	personality.updated_strategic_trait.connect(
			strategic_trait_display._on_trait_data_updated)


func connect_to_player(player:PlayerEntity):
	offesnive_trait_display.connect_to_battle_trait(player.offensive_trait)
	defensive_trait_display.connect_to_battle_trait(player.defensive_trait)
	strategic_trait_display.connect_to_battle_trait(player.strategic_trait)
	
	player.data.card_collected.connect(func(card:CardData):
		card_effects_manager.add_card_effect(card, Vector2(725, 21)))
	player.data.card_removed.connect(func(card:CardData):
		card_effects_manager.remove_card_effect(card))
	
	player.start_ai_processing.connect(show_generation_overlay)
	player.end_ai_processing.connect(hide_generation_overlay)
	pass

func show_generation_overlay() -> void:
	generation_screen.visible = true

func hide_generation_overlay() -> void:
	generation_screen.visible = false


func disconnect_from_player(player: PlayerEntity):
	offesnive_trait_display.disconnect_from_battle_trait(player.offensive_trait)
	defensive_trait_display.disconnect_from_battle_trait(player.defensive_trait)
	strategic_trait_display.disconnect_from_battle_trait(player.strategic_trait)
	player.data.card_collected.disconnect(func(card:CardData):
		card_effects_manager.add_card_effect(card, Vector2(725, 21)))
	player.data.card_removed.disconnect(func(card:CardData):
		card_effects_manager.remove_card_effect(card))


func _on_health_updated(current:int, max:int):
	health_label.text = str(current) + "/" + str(max)
	pass


func _on_view_card_deck() -> void:
	deck_viewer.visible = true


func open_card_removal():
	var run = GlobalSessionManager.run_progress
	
	if run:
		card_remover.initialize(run.player_data.cards)
		card_remover.visible = true


func open_card_picker(cards:Array[CardData], 
	allow_stat_mod:bool = false):
	card_picker.initialize(cards)
	card_picker.visible = true
	
	modify_stat_button.visible = allow_stat_mod
	close_card_picker_button.visible = !allow_stat_mod


func _on_settings_button_up() -> void:
	options_menu.visible = true
	pass # Replace with function body.


func open_stat_modifier() -> void:
	stat_modifier.initialize()
	stat_modifier.visible = true


func _on_close_card_picker_button_up() -> void:
	card_picker.visible = false
	card_picker.closed.emit(false)
	pass # Replace with function body.


func _on_modify_stat_button_up() -> void:
	card_picker.visible = false
	stat_modifier.initialize()
	stat_modifier.visible = true
	pass # Replace with function body.


func reset_stats_to_base_display():
	var run = GlobalSessionManager.run_progress
	if run:
		offesnive_trait_display._on_trait_data_updated(
				run.player_data.personality.offensive_trait,
				run.player_data.personality.offensive_weight
		)
		
		defensive_trait_display._on_trait_data_updated(
				run.player_data.personality.defensive_trait,
				run.player_data.personality.defensive_weight
		)
		
		strategic_trait_display._on_trait_data_updated(
				run.player_data.personality.strategic_trait,
				run.player_data.personality.strategic_weight
		)
