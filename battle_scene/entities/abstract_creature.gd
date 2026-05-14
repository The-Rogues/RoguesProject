@abstract
extends AbstractEntity
class_name AbstractCreature

signal finished_moving
signal defeated(creature:AbstractCreature)

@export var effects:StatusEffectController
@export var block:Block
@export var animation_player:AnimationPlayer
@export var stat_display:CreatureStatDisplay

var is_moving:bool = false


func apply_status_effect(effect:StatusEffectConfig):
	effects.add_effect(effect.behaviour, effect.duration, effect.stack, effect.turn_entered)


func play_idle_anim():
	animation_player.play("idle")


func play_death_anim():
	animation_player.play("death")
	await animation_player.animation_finished


func play_attack_anim():
	animation_player.play("attack")
	await animation_player.animation_finished
	animation_player.play("idle")


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


func enter_turn(_turn_count:int):
	block.set_to_zero()
	#effects.on_entered_turn()
	#effects.decay_status_effects()


func _on_projectile_fired(projectile:Projectile):
	effects.process_projectile(projectile)
