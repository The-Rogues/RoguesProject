# Author: Fabian

# Adds additional variables for BattleEntity that is intended to be an enemy
# Also used to identify if a BattleEntity is an enemy

extends EntityData
class_name BattleEntityData

signal new_move_chosen(enemy_action:BattleMove)


# Stores all possible moves the enemy can choose from and additional
# information for display
@export var move_set:Array[BattleMove]
var next_move:BattleMove

func get_battle_move():
	var move:BattleMove = move_set.pick_random()
	new_move_chosen.emit(move)
	return move
