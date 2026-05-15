extends BattlePower
class_name ShiftyPower

var player: PlayerEntity

func on_apply(_context:BattleContext):
	player = _context.get_player()
	player.movement_controller.entered_new_position.connect(_on_move)

func _on_move():
	player.block.add_block(3)
