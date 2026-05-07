extends Node

@export var battle_reward: BattleReward
@onready var hover: AudioStreamPlayer = $Hover
@onready var accepted: AudioStreamPlayer = $Accepted
@export var accept_reward: Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	accept_reward.mouse_entered.connect(
		func():
			hover.play()
	)
	
	battle_reward.accepted.connect(
		func():
			reparent(battle_reward.get_parent())
			accepted.finished.connect(queue_free)
			accepted.play()
	)
