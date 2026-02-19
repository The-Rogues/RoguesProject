extends TargetedBattleAction
class_name DamageEntityAction

@export_range(0, 999) var damage:int = 6

@export_group("Damage Sampling")
enum SampleFrom {
	OFFENSIVE_WEIGHT,
	DEFENSIVE_WEIGHT,
	STRATEGIC_WEIGHT
	}
@export var sample_from:SampleFrom
@export var use_damage_sampling:bool = false
@export_group("Status Effects")
@export var status_effects:Array[StatusEffectAction]

func _execute(battle_instance:BattleManager, action_user:BattleEntity):
	targeting = _resolve_target(battle_instance, action_user)
	var final_damage:int = damage
	var sampled_damage:int = 0
	
	if use_damage_sampling:
		match sample_from:
			SampleFrom.OFFENSIVE_WEIGHT:
				sampled_damage = battle_instance.character_personality.offensive_weight
			SampleFrom.DEFENSIVE_WEIGHT:
				sampled_damage = battle_instance.character_personality.defensive_weight
			SampleFrom.STRATEGIC_WEIGHT:
				sampled_damage = battle_instance.character_personality.strategic_weight
		final_damage += sampled_damage
	
	if action_user:
		final_damage = action_user.get_attack_damage(final_damage)
	
	var battle_object:ObjectEntity = \
			battle_instance.battle_field.get_object_infront_of_player()
	if battle_object:
		final_damage = final_damage * battle_object.data.damage_amplifier
	
	for target in targeting:
		if battle_object:
			if battle_object.data.attack_filter == ObjectEntityData.AttackFilter.BLOCK:
				battle_object.take_damage(final_damage, action_user)
				await battle_instance.action_delay()
				continue
		
		target.take_damage(final_damage, action_user)
		
		if targeting.size() == 1:
			await battle_instance.action_delay()
		else:
			await battle_instance.get_tree().create_timer(0.05).timeout
		
		for status_effect in status_effects:
			var new_status_action:StatusEffectAction = status_effect
			new_status_action.target = TargetType.INHERITED
			new_status_action.inherited_targeting = [target]
			battle_instance.action_queue.enqueue(
				new_status_action,
				battle_instance,
				action_user
			)
