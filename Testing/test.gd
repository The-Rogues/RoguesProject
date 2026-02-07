extends Node2D
@onready var deck_viewer_ui: DeckViewerUI = $DeckViewerUI

@export var card_deck:CardDeck 


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	deck_viewer_ui._initialize(card_deck.get_deck_as_array())
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
