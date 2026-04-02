@abstract
extends AbstractEntity
class_name AbstractCreature

signal finished_moving

@export var effects:StatusEffectController
@export var block:Block
@export var animation_player:AnimationPlayer

var is_moving:bool = false

func play_idle_anim():
	animation_player.play("idle")


func play_death_anim():
	animation_player.play("death")
	await animation_player.animation_finished


func play_attack_anim():
	animation_player.play("attack")
	await animation_player.animation_finished


func move_to(new_position:Vector2):
	if is_moving:
		return
	
	is_moving = true
	
	# Tween is a script that changes a passed property over time
	# Tweens finish when the passed paramater reaches a specified value
	var tween = get_tree().create_tween()
	# Interpolate entity position to new position in half a second
	tween.tween_property(self, "global_position", new_position, 0.5)
	# Waits until entity is at new position
	await tween.finished
	finished_moving.emit()
	is_moving = false
