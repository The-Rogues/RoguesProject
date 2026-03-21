extends Control
class_name GameSessionDisplay

@onready var character_name: Label = $Container/LeftElements/Character/Name
@onready var current_health: Label = $Container/LeftElements/Character/Health/CurrentHealth
@onready var character_context: ContextPanel = $Container/LeftElements/Character/Health/Heart/Context

@onready var traits_display: TraitDisplay = $Container/LeftElements/Traits/TraitsDisplay
@onready var deck_viewer: CardDeckViewerUI = $DeckViewer
@onready var player_items: PlayerItems = $Container/RightElements/PlayerItems

@onready var deck_button: TextureButton = $Container/RightElements/Deck/DeckButton
@export var in_battle:bool = false
@export var initialize_on_start:bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if initialize_on_start and GlobalSessionManager.run_progress:
		initialize(GlobalSessionManager.run_progress)


func initialize(data:RunProgress):
	character_name.text = data.character_name
	character_context.set_context(character_name.text + "'s current health.")
	current_health.text = str(
			data.current_health
		) + "/" + str(
				data.character_entity_data.max_health
			)
	
	traits_display.initialize(
		data.personality_data
	)
	
	deck_viewer._initialize(
		data.card_deck
	)
	
	#player_items.connect_to_battle(battle_instance)
	player_items.in_battle_scene = false
	player_items._initialize(data.held_items)


func initialize_with_battle(battle_instance:BattleManager, starting_card_deck:CardDeck):
	character_name.text = battle_instance.player_entity.data.name
	character_context.set_context(character_name.text + "'s current health.")
	current_health.text = str(
			battle_instance.player_entity._health.current_health
		) + "/" + str(
				battle_instance.player_entity._health.max_health
			)
	
	traits_display.initialize(
		battle_instance.player_personality
	)
	
	deck_viewer._initialize(
		starting_card_deck
	)
	
	#player_items.connect_to_battle(battle_instance)
	player_items.battle = battle_instance
	player_items.in_battle_scene = in_battle
	player_items._initialize(GlobalSessionManager.run_progress.held_items)
	
	battle_instance.player_entity._health.health_changed.connect(
		_on_health_changed
	)
	in_battle = true


func _on_health_changed(current:int, max:int):
	current_health.text = str(current) + "/" + str(max)
	pass


func disable_deck_viewer(disable:bool):
	deck_button.disabled = disable
