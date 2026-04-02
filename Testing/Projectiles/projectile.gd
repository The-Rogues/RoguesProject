extends CharacterBody2D
class_name Projectile

signal hit(target)

@export var speed:float = 400
@export var damage:int = 0
@export var ignore_block:bool = false
@export var ignore_walls:bool = false
@export var life_span:Timer
@export var target_position:Vector2
#@export var status_effect:AbstractStatusEffect
var direction

var source:AbstractEntity

func _ready() -> void:
	direction = (target_position - global_position).normalized()
	life_span.start()


func _physics_process(delta):
	velocity = direction * speed
	move_and_slide()


func _on_hitbox_body_entered(body):
	if body.get_parent() is AbstractEntity:
		var entity:AbstractEntity = body.get_parent()
		
		if entity == source:
			return
		
		if ignore_block:
			entity.health.take_damage(damage)
		else:
			entity.take_damage(damage, source)
		
		#if status_effect:
			#var effect_instance:AbstractStatusEffect = status_effect.duplicate()
			#wwentity.status_effects.add_effect(effect_instance)
		
		hit.emit(body)
		queue_free()
	elif body.is_in_group("walls"):
		queue_free()
	elif body.get_parent() == source:
		pass


func _on_life_span_timeout() -> void:
	queue_free()
	pass # Replace with function body.
