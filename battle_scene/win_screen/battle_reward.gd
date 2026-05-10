extends PanelContainer
class_name BattleReward

signal accepted
signal not_accepted

@onready var reward_texture: TextureRect = $Contents/RewardTexture
@onready var reward_name: RichTextLabel = $Contents/RewardName
var data:BattleRewardData

func initialize(_data:BattleRewardData):
	reward_texture.texture = _data.display_texture
	reward_name.text = _data.get_reward_name()
	data = _data


func _on_accept_reward_button_up() -> void:
	if data:
		if data.get_reward():
			accepted.emit()
			queue_free()
	else:
		accepted.emit()
	not_accepted.emit() # Not used yet, but may be useful later.
