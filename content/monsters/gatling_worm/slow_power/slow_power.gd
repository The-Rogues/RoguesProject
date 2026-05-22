extends BattlePower
class_name SlowPower

var battle_context: BattleContext = null

func on_apply(_context:BattleContext):
	battle_context = _context
	_context.get_player().movement_controller.entered_new_position.connect(_on_move)
	add_slow_indicator()

func _on_move():
	for i in range(0, battle_context.creature_manager.enemies.size()):
		if battle_context.creature_manager.enemies[i].data.name == "Gatling Worm":
			var dazed_status = StatusEffectConfig.new()
			dazed_status.behaviour = DazedEffect.new()
			dazed_status.stack = 1
			dazed_status.duration = -1
			dazed_status.turn_entered = false
			battle_context.creature_manager.enemies[i].apply_status_effect(dazed_status)

func add_slow_indicator():
	for i in range(0, battle_context.creature_manager.enemies.size()):
		if battle_context.creature_manager.enemies[i].data.name == "Gatling Worm":
			var slow_status = StatusEffectConfig.new()
			slow_status.behaviour = SlowStatusIndicator.new()
			slow_status.stack = 1
			slow_status.duration = -1
			slow_status.turn_entered = false
			battle_context.creature_manager.enemies[i].apply_status_effect(slow_status)
