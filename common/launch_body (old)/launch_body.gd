extends CharacterBody2D
class_name LaunchBody

# Export variables to easily adjust speed in the inspector
@export var speed : float = 400
@export_range(0, 1) var bounce_range:float = 0.35
@export var bounce_count:int = 3
@export var impact_force:int = 6

# Signal emitted when the ball goes out of bounds
var bounces:int = 0

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var timer: Timer = $Timer
@onready var sprite_flasher: SpriteFlasher = $SpriteFlasher
@onready var launch_sound: AudioStreamPlayer = $LaunchSound
@onready var wall_hit_sound: AudioStreamPlayer = $WallHitSound
@onready var hit_box: Area2D = $HitBox

const POP_PARTICLES = preload("res://common/particle_effects/star_pop.tscn")

var is_active:bool = false
var can_bounce:bool = true


func _ready() -> void:
	hit_box.area_entered.connect(_on_hit_box_area_entered)


func initialize(speed:int, bounce:int, impact_damage:int, texture:Texture2D):
	self.speed = speed
	self.bounce_count = bounce
	self.impact_force = impact_damage
	self.sprite_2d.texture = texture


func launch(direction:Vector2):
	velocity = direction.normalized() * speed
	is_active = true

	animation_player.play("launched_entity/spin")

	timer.start()
	timer.timeout.connect(on_timer_ended)

	spawn_particles(global_position)

	visible = true
	sprite_2d.visible = true

	launch_sound.play()


func _physics_process(delta):
	if !is_active:
		return

	# Still handles bouncing against physics bodies
	var collision = move_and_collide(velocity * delta)

	if collision and can_bounce:
		perform_bounce(
			collision.get_normal(),
			collision.get_position()
		)

	check_bounce_limit()


func perform_bounce(normal:Vector2, particle_position:Vector2) -> void:
	can_bounce = false

	bounces += 1

	spawn_particles(particle_position)

	velocity = velocity.bounce(normal)

	var angle_variation = randf_range(-bounce_range, bounce_range)
	velocity = velocity.rotated(angle_variation)

	sprite_flasher.flash()
	wall_hit_sound.play()

	# Prevent double bounce in same frame
	await get_tree().physics_frame
	can_bounce = true


func check_bounce_limit() -> void:
	if bounces < bounce_count:
		return

	velocity = Vector2.ZERO
	is_active = false

	spawn_particles(global_position)

	animation_player.stop(true)

	# Let last sound survive queue_free
	wall_hit_sound.reparent(get_tree().current_scene)
	wall_hit_sound.play()
	wall_hit_sound.finished.connect(wall_hit_sound.queue_free)

	queue_free()


func spawn_particles(new_position:Vector2):
	var particles:CPUParticles2D = POP_PARTICLES.instantiate()

	get_parent().add_child(particles)

	particles.global_position = new_position
	particles.emitting = true

	await particles.finished
	particles.queue_free()


func on_timer_ended():
	queue_free()


func _on_timer_timeout() -> void:
	queue_free()


func _on_hit_box_area_entered(area: Area2D) -> void:
	if !is_active:
		return

	if !can_bounce:
		return

	# Ignore self
	if area == hit_box:
		return
	
	var entity := area.get_parent() as AbstractEntity
	
	if entity:
		entity.take_damage(randi_range(1, 2), null)
	
	# Calculate bounce normal manually
	var bounce_normal = (global_position - area.global_position).normalized()

	perform_bounce(bounce_normal, global_position)

	check_bounce_limit()
