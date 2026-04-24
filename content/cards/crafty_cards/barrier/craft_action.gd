extends Action
class_name CraftAction

var crafted_wall: ObjectData = preload("res://content/objects/crafted_wall/crafted_wall.tres")

func execute(_context:BattleContext = null, _user:AbstractEntity = null):
	if _user is not PlayerEntity:
		return
	
	if _user.battle_position.get_object() != null:
		return
	
	_context.battle_field.place_object(crafted_wall, _user.battle_position)
	var new_wall: ObjectEntity = _user.battle_position.get_object()
	var init_health: int = _user.defensive_trait.weight_value * 4
	new_wall.health.set_values(init_health, init_health)
	_user.defensive_trait.set_weight(1)
	await _context.battle_field.get_tree().create_timer(0.15).timeout
