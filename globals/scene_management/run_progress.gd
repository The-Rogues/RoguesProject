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
var player_data:PlayerData = null

# Immutable
var player_texture:Texture2D = null
var player_name:String
var player_backstory:String = "Has an unkown past"

# -------------------------------------------------
# Map progress tracking member values
# -------------------------------------------------
var run_map: MapManager
var map_seed: int = 0
var floor_progress:int = 1
var current_floor:int = 1
var player_node_index: int = 0
var battle: BattleSaveData = null
var pending_node_index: int = -1
var room_in_progress: bool = false
var pending_room_type: int = -1

# -------------------------------------------------
# Statistics tracking member values
# -------------------------------------------------
var total_gold_collected:int = 0
var total_cards_collected:int = 0
var total_items_collected:int = 0
var total_personality_shifts:int = 0
var total_rooms_explored:int = 0

var initialized:bool = false
