### game_stats_data.gd
extends Resource
class_name GameStatsData

@export var runs_completed:int = 0
@export var personality_trait_shifts:int = 0
@export var personalities_used:Array[String] = []

@export var used_items:Array[String] = []
@export var total_items_used:int = 0
@export var total_chests_opened:int = 0
@export var total_objects_placed:int = 0
@export var total_gold_collected:int = 0

@export var enemy_encounters_defeated:Array[String] = []
@export var cards_collected:Array[String] = []
