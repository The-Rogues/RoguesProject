extends BattlePower
class_name KeepBlock

var last_turn_block:int = 0
var context:BattleContext

func on_apply(_context:BattleContext):
	_context.get_player().block.updated.connect(_on_block_changed)


func _on_block_changed(current:int):
	if current > 0:
		last_turn_block = current
	else:
		last_turn_block = 0


func on_turn_entered(_context:BattleContext):
	if last_turn_block > 0:
		_context.get_player().block.add_block(last_turn_block)
