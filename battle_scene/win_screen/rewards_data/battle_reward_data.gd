@abstract
extends Resource
class_name BattleRewardData

@export var display_texture:Texture2D
@export var name:String

@abstract
func get_reward() -> bool


func get_reward_name() -> String:
	return name
