extends FriendBehaviour
class_name TurtleFriend


func get_friend_texture() -> Texture2D:
	return load("res://content/friends/turtle/turtle_texture.tres")


func _on_card_played(_card:CardInstance):
	if _card.data.play_actions[0] is BlockAction:
		await instance.wait_random_time()
		owner.block.add_block(1)
