extends AbstractEntity
class_name ObjectEntity


var data:ObjectData
@onready var animation_player:AnimationPlayer = $AnimationPlayer
@onready var sprite_2d:Sprite2D = $Sprite2D
@onready var sprite_flasher: SpriteFlasher = $SpriteFlasher


func initialize(data:ObjectData):
	self.data = data
	health.initialize(data.health, data.health)
	sprite_2d.texture = data.display_texture


func take_damage(amount:int, _attacker = null):
	attacker = _attacker
	health.take_damage(amount)
	
	sprite_flasher.flash()
	queue_actions.emit(data.on_hit_actions)


func on_destroyed():
	queue_actions.emit(data.on_destroyed_actions)
	sprite_flasher.flash()
	await play_destroyed_anim()


func enter_turn():
	queue_actions.emit(data.on_turn_entered_actions)


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
