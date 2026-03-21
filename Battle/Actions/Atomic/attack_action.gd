extends TargetedBattleAction
class_name AttackAction
## An action that deals damage to targeted entities with configurable damage,
## repeating hits, and optional secondary effects.
##
## Use as a component in an instance of a [BattleMove]

## The base damage that the attack will deal.
@export var damage_sample:DamageValue

## Times the attack will be repeated. 1 = Hit Once.
@export_range(1, 99) var hits:int = 1

func _execute(battle_instance:BattleManager, _action_user:BattleEntity = null):
	for hit in hits:
		await _apply_hit(battle_instance, _action_user)


func _apply_hit(
	battle_instance:BattleManager,
	action_user:BattleEntity,
):
	var damage = damage_sample.get_damage(battle_instance, action_user)
	damage = action_user.get_attack_damage(damage)
	var battle_object = battle_instance.battle_field.get_object()
	
	for target in targets:
		# Object interception
		if _object_intercepts(battle_object, damage, action_user):
			battle_object.take_damage(damage, action_user)
			await battle_instance.action_delay()
			continue
		
		# Deal damage
		target.take_damage(damage, action_user)
		
		await _damage_delay(battle_instance)


func _object_intercepts(
	battle_object:ObjectEntity,
	damage:int,
	action_user:BattleEntity
) -> bool:
	if not battle_object:
		return false
	
	match battle_object.data.attack_filter:
		ObjectEntityData.AttackFilter.BLOCK:
			return true
		ObjectEntityData.AttackFilter.INTERCEPT:
			battle_object.take_damage(damage, action_user)
			return true
	
	return false


func _damage_delay(battle_instance:BattleManager):
	# Delay is different so that if multiple entities are targeted, they play
	# damage animations in unison vs sequentially.
	if targets.size() == 1:
		await battle_instance.action_delay()
	else:
		await battle_instance.get_tree().create_timer(0.05).timeout
