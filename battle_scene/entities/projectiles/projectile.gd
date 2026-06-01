extends CharacterBody2D
class_name Projectile
## Scripted behaviour for a projectile object.
##
## Handles movement, collision detection and behaviour, and frees its own memory
## if it collides with a valid object or exceeds its own life span.
## Author: Fabian

signal hit(hit_body)
signal freed(projectile: Projectile)

@export var speed: float = 420
@export var impact_damage: int = 6 
@export var pass_through_objects: bool = false
@export var face_velocity_direction: bool = true
@export var impact_status_effect: StatusEffectConfig

var target_position: Vector2
var direction: Vector2 = Vector2(1,0)
var source

@onready var life_span: Timer = $LifeSpanTimer
@onready var sprite_pivot: Node2D = $SpritePivot

func _ready() -> void:
	if life_span:
		life_span.timeout.connect(_on_life_span_timeout)
		life_span.start()


func _physics_process(_delta: float) -> void:
	velocity = direction * speed
	move_and_slide()

	if face_velocity_direction and velocity.length_squared() > 0:
		sprite_pivot.rotation = lerp_angle(
			sprite_pivot.rotation,
			velocity.angle(),
			0.3
		)


func initialize(start_pos: Vector2, target_pos: Vector2):
	global_position = start_pos
	target_position = target_pos
	direction = start_pos.direction_to(target_pos)


func _on_hitbox_area_entered(area: Area2D) -> void:
	var entity := area.get_parent() as AbstractEntity
	
	# Hit non-entity objects
	if entity == null:
		_remove_projectile()
		return
	
	# Ignore invalid targets
	if _can_impact_damage_entity(entity):
		_handle_entity_collision(entity)


func _can_impact_damage_entity(entity: AbstractEntity) -> bool:
	if !entity.health.is_alive:
		return false

	if is_in_group("Player") and entity.is_in_group("Player"):
		return false

	if is_in_group("Enemies") and entity.is_in_group("Enemies"):
		return false

	if entity.is_in_group("Objects") and pass_through_objects:
		return false

	return true


func _handle_entity_collision(hit_entity: AbstractEntity):
	hit_entity.take_damage(impact_damage, self)

	if hit_entity is AbstractCreature and impact_status_effect:
		hit_entity.apply_status_effect(impact_status_effect)

	hit.emit(hit_entity)
	
	_remove_projectile()


func _remove_projectile() -> void:
	freed.emit(self)
	queue_free()


func _on_life_span_timeout() -> void:
	_remove_projectile()


func _on_hit_box_body_entered(body: Node2D) -> void:
	_remove_projectile()
	pass # Replace with function body.
