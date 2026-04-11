extends AbstractEntity
class_name ObjectEntity

signal interacted(object:ObjectEntity)

var data:ObjectData
@onready var animation_player:AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: HitFlash = $Sprite2D
@onready var object_stat_display: ObjectStatDisplay = $ObjectStatDisplay


func initialize(_data:ObjectData):
	data = _data
	health.initialize(_data.health, data.health)
	sprite_2d.texture = _data.display_texture
	object_stat_display.initialize(self)


func take_damage(amount:int, _attacker = null):
	attacker = _attacker
	health.take_damage(amount)
	
	sprite_2d.flash()
	
	if (_attacker is PlayerEntity 
			and health.is_alive
			and data.interaction == ObjectData.InteractionOption.ON_HIT):
		interacted.emit(self)


func on_destroyed():
	#queue_actions.emit(data.on_destroyed_actions)
	sprite_2d.flash()
	await play_destroyed_anim()


func enter_turn():
	pass
	#queue_actions.emit(data.on_turn_entered_actions)


func on_placed():
	pass


func play_idle_anim():
	animation_player.play("idle")


func play_destroyed_anim():
	animation_player.play("destroyed")
	await animation_player.animation_finished


func play_action_anim():
	animation_player.play("action")
	await animation_player.animation_finished
