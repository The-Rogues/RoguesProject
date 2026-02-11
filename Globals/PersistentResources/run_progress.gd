# Stores game information that can be saved and reloaded
# Also accessed throughout the game to update player progess
extends Resource
class_name RunProgress


@export var character_data:CharacterData
@export var card_deck:CardDeck
@export var heald_items:Array[ItemData]
@export var item_capacity:int = 3
@export var backstory:String
@export var experience_log:Array[String] = []
@export var map_seed: int = 0
@export var player_node_index: int = 0
@export var battle: BattleSaveData = null

var run_map: MapManager
@export var floor_progress:int = 1
@export var current_floor:int = 1
@export var gold:int = 0

func _init(
	new_character_data:CharacterData = null,
	new_backstory:String = "",
) -> void:
	character_data = new_character_data
	backstory = new_backstory
	
	card_deck = load("res://CardSystem/Decks/starting_card_deck.tres")
	heald_items = []
	item_capacity = 3
	current_floor = 1
	floor_progress = 1
	gold = 100
