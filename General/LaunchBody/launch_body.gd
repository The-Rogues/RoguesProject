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

const POP_PARTICLES = preload(
	"res://General/Effects/Particles/star_pop.tscn"
)
var is_active:bool = false


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


func _physics_process(delta):
	if !is_active:
		return
	
	var collision = move_and_collide(velocity * delta)
	
	if collision:
		bounces +=1
		var bounce_direction = collision.get_normal()
		spawn_particles(collision.get_position())
		velocity = velocity.bounce(bounce_direction)
		var angle_variation = randf_range(-bounce_range, bounce_range)
		velocity = velocity.rotated(angle_variation)
		sprite_flasher.flash_sprite()
	
	if bounces >= bounce_count:
		velocity = Vector2.ZERO
		is_active = false
		spawn_particles(global_position)
		animation_player.stop(true)
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
	pass


func _on_timer_timeout() -> void:
	queue_free()
	pass # Replace with function body.
