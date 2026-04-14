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

func initialize():
	var run:RunProgress = GlobalSessionManager.run_progress
	
	run.player_data.cards_updated.connect(deck_ui._on_card_pile_updated)
	player_items.initialize()
	gold_label.initialize()
	name_label.text = run.player_name
	health_label.text = str(run.player_data.current_health) + "/" + str(run.player_data.max_health)
	
	offesnive_trait_display.connect_to_data("OFFENSIVE", run.player_data.personality)
	defensive_trait_display.connect_to_data("DEFENSIVE", run.player_data.personality)
	strategic_trait_display.connect_to_data("STRATEGIC", run.player_data.personality)
	
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
	
	
	deck_viewer.display_cards_from_data(run.player_data.cards)
	deck_ui._on_deck_updated(run.player_data.cards)
	
	run.player_data.cards_updated.connect(deck_ui._on_deck_updated)
	run.player_data.cards_updated.connect(deck_viewer.display_cards_from_data)
	run.player_data.items_updated.connect(player_items._on_items_updated)
	run.player_data.health_updated.connect(_on_health_updated)


func connect_to_player(player:PlayerEntity):
	offesnive_trait_display.connect_to_battle_trait(player.offensive_trait)
	defensive_trait_display.connect_to_battle_trait(player.defensive_trait)
	strategic_trait_display.connect_to_battle_trait(player.strategic_trait)
	pass


func disconnect_from_player(player: PlayerEntity):
	offesnive_trait_display.disconnect_from_battle_trait(player.offensive_trait)
	defensive_trait_display.disconnect_from_battle_trait(player.defensive_trait)
	strategic_trait_display.disconnect_from_battle_trait(player.strategic_trait)


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


func open_card_picker(cards:Array[CardData]):
	card_picker.initialize(cards)
	card_picker.visible = true


func _on_settings_button_up() -> void:
	options_menu.visible = true
	pass # Replace with function body.
