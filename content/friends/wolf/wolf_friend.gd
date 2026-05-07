extends FriendBehaviour
class_name WolfFriend


func get_friend_texture() -> Texture2D:
	return load("res://content/friends/wolf/wolf_texture.tres")


func _on_entity_attacked(_entity:AbstractEntity):
	if _entity.health:
		await instance.wait_random_time()
		await instance.play_attack()
	
		if is_instance_valid(_entity):
			_entity.take_damage(randi_range(5, 9), owner)
