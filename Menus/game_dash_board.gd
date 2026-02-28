extends Control
class_name GameSessionDisplay

@onready var character_name: Label = $Container/LeftElements/Character/Name
@onready var current_health: Label = $Container/LeftElements/Character/Health/CurrentHealth
@onready var character_context: ContextPanel = $Container/LeftElements/Character/Health/Heart/Context

@onready var traits_display: TraitDisplay = $Container/LeftElements/Traits/TraitsDisplay
@onready var deck_viewer: CardDeckViewerUI = $DeckViewer
@onready var item_interface: ItemInterface = $Container/RightElements/Items/ItemInterface
@onready var deck_button: TextureButton = $Container/RightElements/Deck/DeckButton


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if GlobalSessionManager.run_progress:
		pass
	else:
		pass

func initialize_with_battle(battle_instance:BattleManager, starting_card_deck:CardDeck):
	character_name.text = battle_instance.player_entity.data.name
	character_context.set_context(character_name.text + "'s current health.")
	current_health.text = str(
			battle_instance.player_entity._health.current_health
		) + "/" + str(
				battle_instance.player_entity._health.max_health
			)
	
	traits_display.initialize(
		battle_instance.character_personality
	)
	
	deck_viewer._initialize(
		starting_card_deck
	)
	
	item_interface.initialize(
		battle_instance.held_items
	)
	
	battle_instance.player_entity._health.health_changed.connect(
		_on_health_changed
	)
	
	battle_instance.item_used.connect(_on_item_used)


func _on_health_changed(current:int, max:int):
	current_health.text = str(current) + "/" + str(max)
	pass


func _on_item_used(item:ItemData, remaining:Array[ItemData]):
	item_interface.update_ui(remaining)


func disable_deck_viewer(disable:bool):
	deck_button.disabled = disable
