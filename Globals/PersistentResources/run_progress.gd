extends Resource
class_name RunProgress
## A resource that stores information on the player's progress from a session
## of the game.
##
## Stores the character's stats, personality, held items, experiences, gold,
## and map progress. Intended to be created, deleted, stored, and loaded by
## a save system.

# -------------------------------------------------
# Personality system member values
# -------------------------------------------------
@export var personality_data:PersonalityData = null
@export var character_entity_data:EntityData = null
@export var current_health:int = 80
@export var max_energy:int = 5
@export var character_backstory:String = "Has an unkown past"
@export var character_experience_log:Array[String] = []

# -------------------------------------------------
# Map progress tracking member values
# -------------------------------------------------
var run_map: MapManager
@export var map_seed: int = 0
@export var floor_progress:int = 1
@export var current_floor:int = 1
@export var player_node_index: int = 0
@export var battle: BattleSaveData = null

# -------------------------------------------------
# Loot progress tracking member values
# -------------------------------------------------
@export var card_deck:CardDeck = null
@export var held_items:Array[ItemData] = []
@export_range(1, 6) var maximum_item_capacity:int = 3
@export_range(0, 9999) var gold:int = 0

# -------------------------------------------------
# Statistics tracking member values
# -------------------------------------------------
var total_gold_collected:int = 0
var total_cards_collected:int = 0
var total_items_collected:int = 0
var total_personality_shifts:int = 0
var total_rooms_explored:int = 0

var _initialized:bool = false


## Use to create data for a new run of the game.
func initialize_new_run(
	character_texture: Texture2D,
	character_name: String,
	character_backstory: String,
	personality_data: PersonalityData,
	card_deck: CardDeck
) -> void:
	## Guardrail to prevent duplicate initialization
	if _initialized:
		push_error("RunProgress.initialize_new_run() called more than once.")
		return
	_initialized = true
	
	self.personality_data = personality_data
	self.character_entity_data = EntityData.new()
	self.character_entity_data.id = "player"
	self.character_entity_data.display_texture = character_texture
	self.character_entity_data.name = character_name
	self.character_entity_data.max_health = 80
	self.current_health = 80
	self.character_entity_data.description = character_backstory
	self.max_energy = 5
	self.character_backstory = character_backstory
	self.character_experience_log = []
	
	self.map_seed = 0
	self.floor_progress = 1
	self.current_floor = 1
	self.player_node_index = 0
	self.battle = null
	self.run_map = null  # always reconstructed from seed
	
	self.card_deck = card_deck.duplicate(true)
	self.held_items = []
	self.maximum_item_capacity = 3
	self.gold = 0
	
	self.total_gold_collected = 0
	self.total_cards_collected = 0
	self.total_items_collected = 0
	self.total_personality_shifts = 0
	self.total_rooms_explored = 0
