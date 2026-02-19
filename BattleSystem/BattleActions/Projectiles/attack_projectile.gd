extends Area2D
class_name AttackProjectile

enum DamageTarget {PLAYER, ENEMY}
@export var damages:DamageTarget
@export var speed: float = 500.0
@export var timer: Timer
@export var sprite_2d: Sprite2D
@export var damage:int
@export var face_direction:bool
const POOF_PARTICLE = preload("res://GeneralAssets/ParticleEffects/poof.tscn")
var active:bool = false
var velocity: Vector2 = Vector2.ZERO
var projectile_owner

#func _ready():
	# Connect the body_entered signal to a function to handle collisions
	#body_entered.connect(_on_body_entered)
	# Connect the Timer's timeout signal to queue_free
	#timer.timeout.connect(_on_timer_timeout)

func _physics_process(delta):
	if !active:
		return
	# Move the projectile based on its velocity
	global_position += velocity * delta

func configure(
	new_owner:Node2D,
	replacement_texture:Texture2D,
	new_speed:float,
	new_damage:int,
	new_face_direction:bool
):
	projectile_owner = new_owner
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

func _on_body_entered(body):
	var entity = body.get_parent()
	if entity is not BattleEntity and entity is not ObjectEntity:
		return
	
	var collision_projectile_owner = body.get_parent()
	
	if collision_projectile_owner != projectile_owner:
		if collision_projectile_owner is ObjectEntity:
			if collision_projectile_owner.data.attack_filter != ObjectEntityData.AttackFilter.IGNORE:
				collision_projectile_owner.take_damage(damage)
		else:
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
	var particles:CPUParticles2D = POOF_PARTICLE.instantiate()
	get_parent().add_child(particles)
	particles.global_position = position
	particles.emitting = true
	await particles.finished
	particles.queue_free()
