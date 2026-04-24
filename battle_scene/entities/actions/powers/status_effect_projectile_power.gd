extends BattlePower
class_name StatusEffectProjectilePower


@export var status:StatusEffectConfig


func on_apply(_context:BattleContext):
	_context.get_player().projectile_launcher.fired_projectile.connect(
		_on_fired_projectile
	)


func _on_fired_projectile(projectile:Projectile):
	projectile.status = status
