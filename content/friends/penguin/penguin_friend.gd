extends FriendBehaviour
class_name PenguinFriend

@export var projectile_data:ProjectileFireData

func get_friend_texture() -> Texture2D:
	return load("res://content/friends/penguin/penguin_texture.tres")


func _on_entity_attacked(_entity:AbstractEntity):
	if _entity.health:
		await instance.wait_random_time()
		await instance.play_attack()
	
		if is_instance_valid(_entity):
			instance.projectile_launcher.fire_projectile(
				_entity.global_position, 
				projectile_data)
