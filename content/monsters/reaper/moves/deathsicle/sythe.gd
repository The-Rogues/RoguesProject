extends Projectile

var current_direction

func _ready() -> void:
	current_direction = (target_position - global_position).normalized()
	
	# Add arc randomness
	var offset = current_direction
	offset.x += randf_range(-2, 2) # keep this small
	
	current_direction = offset.normalized()
	velocity = current_direction * speed
	
	life_span.start()


func _physics_process(delta):
	var target_dir = (target_position - global_position).normalized()
	
	# Smoothly steer toward target
	current_direction = current_direction.lerp(target_dir, 0.05)
	current_direction = current_direction.normalized()
	
	velocity = current_direction * speed
	move_and_slide()
