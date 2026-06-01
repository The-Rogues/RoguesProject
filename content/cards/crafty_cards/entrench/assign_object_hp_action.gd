extends Action
class_name AssignObjectHPAction

@export var amount: int = 1
var crafted_wall: ObjectData = preload("res://content/objects/crafted_wall/crafted_wall.tres")

func execute(_context:BattleContext = null, _user:AbstractEntity = null):
	
	var track_achievement: bool = false
	if _user is PlayerEntity:
		track_achievement = true
	
	if _user is not PlayerEntity:
		return
	
	if _user.battle_position.get_object() != null && _user.battle_position.get_object().health.is_alive:
		return
	
	_context.battle_field.place_object(crafted_wall, _user.battle_position)
	var new_wall: ObjectEntity = _user.battle_position.get_object()
	new_wall.health.set_values(amount, amount)
	
	if track_achievement:
		Events.object_placed.emit(new_wall)
	
	await _context.battle_field.get_tree().create_timer(0.15).timeout
