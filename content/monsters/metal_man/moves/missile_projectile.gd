extends Projectile

func _physics_process(delta):
	velocity.y += speed * delta
	move_and_slide()
	
	if global_position.distance_squared_to(target_position) < 1:
		queue_free()
