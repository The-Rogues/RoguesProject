extends Action
class_name PlayerCarryObjectAction


@export var object:ObjectData


func execute(_context:BattleContext = null, _user:AbstractEntity = null):
	_context.get_player().carry_object(object)
	await _context.battle_field.get_tree().create_timer(0.15).timeout
