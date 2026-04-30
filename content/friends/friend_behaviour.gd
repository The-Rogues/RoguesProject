@abstract
extends Resource
class_name FriendBehaviour


var context:BattleContext
var owner:PlayerEntity
var instance:Friend


func initialize(_context:BattleContext, _owner:PlayerEntity, _instance:Friend):
	context = _context
	owner = _owner
	instance = _instance
	
	_owner.played_card.connect(_on_card_played)
	_owner.turn_entered.connect(_on_turn_entered)
	_owner.attacked_entity.connect(_on_entity_attacked)


@abstract
func get_friend_texture() -> Texture2D


func _on_card_played(_card:CardInstance):
	pass


func _on_turn_entered():
	pass


func _on_entity_attacked(_entity:AbstractEntity):
	pass
