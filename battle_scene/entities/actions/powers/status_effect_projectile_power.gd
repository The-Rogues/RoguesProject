extends BattlePower
class_name StatusEffectProjectilePower


@export var status:StatusEffectConfig


func on_apply(_context:BattleContext):
	_context.get_player().projectile_launcher.fired_projectile.connect(
		_on_fired_projectile
	)


func _on_fired_projectile(projectile:Projectile):
	if projectile.status == null:
		projectile.status = status
	elif projectile.status.behaviour == status.behaviour:
		projectile.status = projectile.status.duplicate(true)
		projectile.status.stack += status.stack
