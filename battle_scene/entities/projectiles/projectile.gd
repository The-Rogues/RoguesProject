extends CharacterBody2D
class_name Projectile

signal hit(target)
signal freed(projectile: Projectile)

@export var speed: float = 400
@export var damage: int = 0
@export var ignore_walls: bool = false
@export var face_move_direction: bool = true
@export var status: StatusEffectConfig
@export var target_position: Vector2
@export var life_span: Timer

@onready var sprite_pivot: Node2D = $SpritePivot

var direction: Vector2
var source


func _ready() -> void:
	direction = global_position.direction_to(target_position)

	if life_span:
		life_span.timeout.connect(_on_life_span_timeout)
		life_span.start()


func _physics_process(_delta: float) -> void:
	velocity = direction * speed
	move_and_slide()

	if face_move_direction and velocity.length_squared() > 0:
		sprite_pivot.rotation = lerp_angle(
			sprite_pivot.rotation,
			velocity.angle(),
			0.3
		)


func _on_hitbox_area_entered(area: Area2D) -> void:
	var entity := area.get_parent() as AbstractEntity
	
	# Hit non-entity objects
	if entity == null:
		destroy(area)
		return
	
	# Ignore invalid targets
	if !_can_damage_entity(entity):
		return

	entity.take_damage(damage, self)

	if entity is AbstractCreature and status:
		entity.apply_status_effect(status)

	destroy(entity)

	pass # Replace with function body.


func _can_damage_entity(entity: AbstractEntity) -> bool:
	if !entity.health.is_alive:
		return false

	if is_in_group("Player") and entity.is_in_group("Player"):
		return false

	if is_in_group("Enemies") and entity.is_in_group("Enemies"):
		return false

	if is_in_group("Player") and entity.is_in_group("Objects"):
		return false

	return true


func destroy(target = null) -> void:
	hit.emit(target)
	freed.emit(self)
	queue_free()


func _on_life_span_timeout() -> void:
	destroy()
