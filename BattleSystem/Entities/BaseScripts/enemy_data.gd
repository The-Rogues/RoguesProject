# Author: Fabian

# Adds additional variables for BattleEntity that is intended to be an enemy
# Also used to identify if a BattleEntity is an enemy

extends EntityData
class_name EnemyData

signal new_move_chosen(enemy_action:BattleMove)


enum Rarity {COMMON, UNCOMMON, RARE}
# Added to final reward amount at the end of a battle 
@export var reward_amount:int
# Stores all possible moves the enemy can choose from and additional
# information for display
@export var move_set:Array[BattleMove]
@export var rarity:Rarity
var next_move:BattleMove

func choose_next_move() -> void:
	next_move = move_set.pick_random()
	new_move_chosen.emit(next_move)

func get_move_actions() -> Array[BattleAction]:
	return next_move.actions
