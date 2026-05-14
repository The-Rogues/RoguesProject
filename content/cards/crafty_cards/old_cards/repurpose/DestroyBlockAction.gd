extends BlockAction
class_name DestroyBlockAction

@export var block_multiplier: int = 1

func execute(_context:BattleContext = null, _user:AbstractEntity = null):
	if _user is not PlayerEntity:
		return
	if _user.battle_position.get_object() == null:
		return
	var front_object: ObjectEntity = _user.battle_position.get_object()
	amount = front_object.health.value * block_multiplier
	if amount > 50:
		amount = 50
	front_object.health.kill()
	super(_context, _user)
