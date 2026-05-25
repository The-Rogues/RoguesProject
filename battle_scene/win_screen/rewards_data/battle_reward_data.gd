@abstract
extends Resource
class_name BattleRewardData

@export var display_texture:Texture2D
@export var name:String

@abstract
func get_reward() -> bool


# Override
func get_reward_name() -> String:
	return name

func get_reward_texture() -> Texture2D:
	return display_texture
