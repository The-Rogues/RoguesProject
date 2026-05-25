extends BattlePower
class_name FireTippedProjectilePower

var stack: int = 2

func on_apply(_context:BattleContext):
	_context.get_player().projectile_launcher.fired_projectile.connect(
		_on_fired_projectile
	)

func on_stack():
	stack += 2

func _on_fired_projectile(projectile:Projectile):
	if projectile.status == null:
		var burning_effect: StatusEffectConfig = StatusEffectConfig.new()
		burning_effect.behaviour = BurningEffect.new()
		burning_effect.stack = 0
		burning_effect.duration = stack
		burning_effect.turn_entered = true
		projectile.status = burning_effect
