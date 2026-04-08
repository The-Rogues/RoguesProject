extends PanelContainer
class_name BattleReward

@onready var reward_texture: TextureRect = $Contents/RewardTexture
@onready var reward_name: RichTextLabel = $Contents/RewardName
var data:BattleRewardData

func initialize(_data:BattleRewardData):
	reward_texture.texture = _data.display_texture
	reward_name.text = _data.name
	data = _data


func _on_accept_reward_button_up() -> void:
	data.get_reward()
	queue_free()
