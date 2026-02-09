extends Area2D
class_name AttackProjectile

enum DamageTarget {PLAYER, ENEMY}
@export var damages:DamageTarget
@export var speed: float = 500.0
@export var timer: Timer
@export var sprite_2d: Sprite2D
@export var damage:int
@export var face_direction:bool
const POP_PARTICLES = preload("res://GeneralAssets/ParticleEffects/star_pop.tscn")
var active:bool = false
var velocity: Vector2 = Vector2.ZERO

func _ready():
	# Connect the body_entered signal to a function to handle collisions
	body_entered.connect(_on_body_entered)
	# Connect the Timer's timeout signal to queue_free
	timer.timeout.connect(_on_timer_timeout)

func _physics_process(delta):
	if !active:
		return
	# Move the projectile based on its velocity
	global_position += velocity * delta

func configure(
	new_damage_target:DamageTarget,
	replacement_texture:Texture2D,
	new_speed:float,
	new_damage:int,
	new_face_direction:bool
):
	damages = new_damage_target
	sprite_2d.texture = replacement_texture
	speed = new_speed
	damage = new_damage
	if new_face_direction:
		face_direction = true

func spawn_and_launch(spawn_position:Vector2, direction: Vector2):
	# Set the initial velocity when the projectile is created
	global_position = spawn_position
	sprite_2d.visible = true
	velocity = direction * speed
	if face_direction:
		sprite_2d.rotation = direction.angle()-80
	active = true
	print("projectile targeting", damages)

func _on_body_entered(body):
	# Handle collision: print a message and destroy the projectile
	var entity = body.get_parent()
	
	if !entity is Entity:
		return
	
	if damages == DamageTarget.PLAYER and entity.entity_data is CharacterData:
		body.get_parent().take_damage(damage)
	elif damages == DamageTarget.ENEMY and entity.entity_data is EnemyData:
		body.get_parent().take_damage(damage)
	elif entity.entity_data is BattleObjectData:
		body.get_parent().take_damage(damage)
	else:
		return
	
	active = false
	sprite_2d.visible = false
	await spawn_particles(global_position)
	queue_free() # Remove the projectile upon collision

func _on_timer_timeout():
	# Remove the projectile after a set time to prevent it from traveling forever
	queue_free()

func spawn_particles(position:Vector2):
	var particles:CPUParticles2D = POP_PARTICLES.instantiate()
	get_parent().add_child(particles)
	particles.global_position = position
	particles.emitting = true
	await particles.finished
	particles.queue_free()
