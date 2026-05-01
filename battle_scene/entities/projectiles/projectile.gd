extends CharacterBody2D
class_name Projectile

signal hit(target)
signal freed(projectile:Projectile)

@export var speed:float = 400
@export var damage:int = 0
@export var ignore_walls:bool = false
@export var life_span:Timer
@export var target_position:Vector2
@onready var sprite_pivot: Node2D = $SpritePivot
@export var face_move_direction:bool = true
@export var status:StatusEffectConfig


var direction
var source:AbstractEntity

func _ready() -> void:
	direction = (target_position - global_position).normalized()
	life_span.start()


func _physics_process(delta):
	velocity = direction * speed
	move_and_slide()
	
	if velocity.length() > 0:
		sprite_pivot.rotation = lerp_angle(
				sprite_pivot.rotation, 
				velocity.angle(), 0.3)


func _on_hitbox_body_entered(body):
	if body.get_parent() is AbstractEntity:
		var entity:AbstractEntity = body.get_parent()
		
		if entity == source:
			return
		
		entity.take_damage(damage, self)
		
		if entity is AbstractCreature and status:
			entity.apply_status_effect(status)
		
		hit.emit(body)
		freed.emit(self)
		queue_free()
	elif body.is_in_group("walls"):
		freed.emit(self)
		queue_free()
	else:
		pass


func _on_life_span_timeout() -> void:
	freed.emit(self)
	queue_free()
	pass # Replace with function body.
