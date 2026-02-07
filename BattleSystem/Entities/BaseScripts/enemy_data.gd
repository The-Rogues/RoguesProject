# Author: Fabian

# Adds additional variables for BattleEntity that is intended to be an enemy
# Also used to identify if a BattleEntity is an enemy

extends BattleEntityData
class_name EnemyData

signal new_move_chosen(enemy_action:EnemyMove)


enum Rarity {COMMON, UNCOMMON, RARE}
# Added to final reward amount at the end of a battle 
@export var reward_amount:int
# Stores all possible moves the enemy can choose from and additional
# information for display
@export var move_set:Array[EnemyMove]
@export var rarity:Rarity
var next_move:EnemyMove

func choose_next_move():
	next_move = move_set.pick_random()
	new_move_chosen.emit(next_move)

func get_combat_moves():
	return next_move.actions

# Constructor
func initialize(
			new_name:String,
			new_move_set:Array[EnemyMove],
			new_behaviours:Array[EntityBehaviour] = []) -> void:
		
		name = new_name
		move_set = new_move_set.duplicate(true)
		health = Stat.new(125, 0, 125, true)
		defense_amplifier = Stat.new(2, 0.25, 1, false)
		attack_amplifier = Stat.new(2, 0.25, 1, false)
		if !new_behaviours.is_empty():
			behaviours = new_behaviours.duplicate(true)
		wait_to_hide_sprite = false
