extends Action
class_name SummonFriendAction

@export var friend:FriendBehaviour
const Friend_Scene = preload("res://content/friends/friend.tscn")

func execute(_context:BattleContext = null, _user:AbstractEntity = null):
	var player = _context.get_player()
	var friend_instance:Friend = Friend_Scene.instantiate()
	player.add_child(friend_instance)
	friend_instance.initialize(friend, _context, player)
	await _context.battle_field.get_tree().create_timer(0.15).timeout
