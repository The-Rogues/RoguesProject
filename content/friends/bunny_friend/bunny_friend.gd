extends FriendBehaviour
class_name BunnyFriend


func get_friend_texture() -> Texture2D:
	return load("res://content/friends/bunny_friend/bunny_texture.tres")


func _on_turn_entered():
	await instance.wait_random_time()
	owner.health.heal(2)
