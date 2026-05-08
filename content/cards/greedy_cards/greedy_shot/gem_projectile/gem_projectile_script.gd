extends Projectile
class_name GemProjectile

func _on_hitbox_body_entered(body):
	if body.get_parent() is AbstractEntity:
		var entity:AbstractEntity = body.get_parent()
		
		if entity == source:
			return
		
		await get_tree().process_frame
		
		entity.take_damage(damage, null)
		
		if entity is AbstractCreature and status:
			entity.apply_status_effect(status)
		
		hit.emit(body)
		freed.emit(self)
		queue_free()
	elif body.is_in_group("walls"):
		freed.emit(self)
		queue_free()
	elif body.get_parent() == source:
		pass
