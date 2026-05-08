extends Resource
class_name RunProgress
## A resource that stores information on the player's progress from a session
## of the game.
##
## Stores the character's stats, personality, held items, experiences, gold,
## and map progress. Intended to be created, deleted, stored, and loaded by
## a save system.

# -------------------------------------------------
# Player Character Info
# -------------------------------------------------
@export var player_data:PlayerData = null

# Immutable
@export var player_texture:Texture2D = null
@export var player_melee_weapon_texture:Texture2D = null
@export var player_ranged_weapon_texture:Texture2D = null
@export var player_name:String
@export var player_backstory:String = "Has an unkown past"

# -------------------------------------------------
# Map progress tracking member values
# -------------------------------------------------
var run_map: MapManager
@export var map_seed: int = 0
@export var floor_progress:int = 1
@export var current_floor:int = 1
@export var player_node_index: int = 0
@export var battle: BattleSaveData = null
@export var pending_node_index: int = -1
@export var room_in_progress: bool = false
@export var pending_room_type: int = -1
@export var single_time_mini_events:Array[MiniEventData]

# -------------------------------------------------
# Statistics tracking member values
# -------------------------------------------------
@export var total_gold_collected:int = 0
@export var total_cards_collected:int = 0
@export var total_items_collected:int = 0
@export var total_personality_shifts:int = 0
@export var total_rooms_explored:int = 0

@export var initialized:bool = false
@export var ai_mode:bool = false
