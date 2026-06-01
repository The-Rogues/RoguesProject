@abstract
extends TargetedAction
class_name DamageAction

var amount:int = 0


func execute(_context:BattleContext = null, _user:AbstractEntity = null):
	# Prevents the player from doing excess damage to the front object when attacking all enemies.
	if _user is PlayerEntity && target_option == TargetOption.ENEMIES && !ignore_foreground:
		if _user.battle_position.get_object() && _user.battle_position.get_object().health.is_alive:
			_user.battle_position.get_object().take_damage(amount, _user)
			await action_resolve_delay()
			return
	
	for target in resolved_targets:
		if !target:
			continue
		if ignore_foreground:
			target.take_damage(amount, _user, true)
		else:
			target.take_damage(amount, _user)
		await action_resolve_delay()
