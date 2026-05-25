extends PositionEffectBehaviour
class_name ArialStrikePositionEffectBehaviour


const MISSILE_PROJECTILE = preload("res://content/monsters/metal_man/moves/missile_projectile.tscn")


func on_entered(player:PlayerEntity, _instance:PositionEffect) -> void:
	pass


func get_effect_name() -> String:
	return "Arial Strike"


func get_description(_instance:PositionEffect) -> String:
	return "A missile will strike this position in " + str(_instance.duration) + " turns."


func on_removed(_instance:PositionEffect) -> void:
	var missile:Projectile = MISSILE_PROJECTILE.instantiate()
	_instance.get_parent().add_child(missile)
	var target_x = _instance.global_position.x
	missile.target_position = _instance.global_position
	missile.global_position = Vector2(target_x, 50)
	#missile.direction = Vector2(0, 1)
