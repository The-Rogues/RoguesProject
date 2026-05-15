extends BattlePower
class_name GrowingFuryPower

var player: PlayerEntity
var reapply_amnt: int = 0

func on_apply(_context:BattleContext):
	player = _context.get_player()
	player.movement_controller.entered_new_position.connect(_on_move)

func _on_move():
	var new_effect_config: StatusEffectConfig = StatusEffectConfig.new()
	new_effect_config.behaviour = ThornsStatusEffectBehaviour.new()
	new_effect_config.stack = 1
	new_effect_config.duration = 1
	new_effect_config.turn_entered = true
	player.apply_status_effect(new_effect_config, true)
	reapply_amnt += 1

func on_turn_entered(_context:BattleContext):
	var new_effect_config: StatusEffectConfig = StatusEffectConfig.new()
	new_effect_config.behaviour = ThornsStatusEffectBehaviour.new()
	new_effect_config.stack = reapply_amnt
	new_effect_config.duration = 1
	new_effect_config.turn_entered = true
	player.apply_status_effect(new_effect_config, true)
