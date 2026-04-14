extends Control
class_name BattleRewardsHandler

@export var rewards_parent: VBoxContainer
const Reward_Entry = preload("res://battle_scene/win_screen/battle_reward.tscn")

var rewards:Array[BattleRewardData]

func add_reward(reward:BattleRewardData):
	rewards.append(reward)


func initialize():
	for reward in rewards:
		var battle_reward = Reward_Entry.instantiate()
		rewards_parent.add_child(battle_reward)
		battle_reward.initialize(reward)



func _on_continue_clicked() -> void:
	GlobalSessionManager.complete_current_room()
	GlobalSceneLoader.load_scene(GlobalSceneLoader.MAP_SCENE_PATH)
	pass # Replace with function body.
