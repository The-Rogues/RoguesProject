extends Projectile

func _physics_process(delta):
	velocity.y += speed * delta
	move_and_slide()
	
	if global_position.distance_squared_to(target_position) < 1:
		queue_free()


func _on_hitbox_body_entered(body):
	if body.get_parent() is AbstractEntity:
		var entity:AbstractEntity = body.get_parent()
		
		if entity is MonsterEntity:
			return
		
		if entity is ObjectEntity:
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
